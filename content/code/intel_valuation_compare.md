+++
date = '2025-09-25T22:28:16Z'
draft = true
title = 'Intel_valuation_compare'
categories = ["code"]
tags = ["blog","code","Stock","Intel"]
+++

좋습니다 — 아래에 PEP8 스타일, 간단하고 깔끔한 구조로 작성한 Python 스크립트를 드립니다.
이 스크립트는:
1. yfinance로 지정한 티커들(기본: Intel + 경쟁사 + 한국 반도체 기업)에서 현재 재무지표(PER, P/B, MarketCap, EnterpriseValue 등)와 1년 주가를 수집합니다.


2. 수집한 데이터를 CSV로 저장합니다.


3. 기본 비교 차트(1년 주가, PER, P/B)를 생성합니다.


4. 간단한 미래 수익 시나리오(EPS 연평균 성장률 가정에 따른 1~5년 후 목표주가 계산)를 제공합니다.

---

사용 전 요구사항(간단): yfinance, pandas, numpy, matplotlib 설치가 필요합니다.
```
pip install yfinance pandas numpy matplotlib
```
아래 코드를 파일(예: intel_valuation_compare.py)로 저장하고 실행하세요.

"""Intel & peers valuation snapshot and simple scenario analysis.
```
Simple, PEP8-compliant script that:
- fetches fundamentals and 1y price history via yfinance
- computes and saves a CSV summary
- plots price history and valuation bar charts
- runs simple EPS-growth scenarios to estimate future prices

Author: ChatGPT (PEP8 style)
"""

from datetime import datetime, timedelta
from typing import Dict, List

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import yfinance as yf


def default_tickers() -> Dict[str, str]:
    """Return default set of tickers for analysis (symbol -> friendly name)."""
    return {
        "INTC": "Intel (INTC)",
        "AMD": "AMD (AMD)",
        "NVDA": "NVIDIA (NVDA)",
        "TSM": "TSMC (TSM)",
        "005930.KS": "Samsung Electronics (005930.KS)",
        "000660.KS": "SK Hynix (000660.KS)",
        "000990.KS": "DB Hitek (000990.KS)",
    }


def fetch_fundamentals(tickers: List[str]) -> pd.DataFrame:
    """Fetch fundamental metrics from yfinance for a list of tickers.

    Returns a DataFrame indexed by ticker with selected columns.
    """
    rows = []
    for tk in tickers:
        ticker = yf.Ticker(tk)
        info = ticker.info or {}
        row = {
            "ticker": tk,
            "shortName": info.get("shortName"),
            "currency": info.get("currency"),
            "regularMarketPrice": info.get("regularMarketPrice"),
            "marketCap": info.get("marketCap"),
            "enterpriseValue": info.get("enterpriseValue"),
            "trailingPE": info.get("trailingPE"),
            "forwardPE": info.get("forwardPE"),
            "priceToBook": info.get("priceToBook"),
            "trailingEps": info.get("trailingEps"),
            "earningsQuarterlyGrowth": info.get("earningsQuarterlyGrowth"),
            "lastDividendValue": info.get("lastDividendValue"),
            "beta": info.get("beta"),
        }
        rows.append(row)
    df = pd.DataFrame(rows).set_index("ticker")
    return df


def fetch_price_history(ticker: str, period: str = "1y") -> pd.DataFrame:
    """Fetch historical price series for a ticker (default 1 year)."""
    data = yf.download(ticker, period=period, progress=False, threads=False)
    return data[["Close"]].rename(columns={"Close": "close"})


def compute_simple_scenarios(
    fundamentals: pd.DataFrame,
    years: int = 5,
    growth_rates: List[float] = None,
    pe_multiple: float = None,
) -> pd.DataFrame:
    """Compute simple EPS-growth scenarios.

    For each ticker:
    - read trailingEps (EPS ttm)
    - project EPS forward with constant annual growth rates
    - apply a P/E multiple (use forwardPE if given, else trailingPE, else pe_multiple)
    Returns DataFrame with projected price per scenario.
    """
    if growth_rates is None:
        growth_rates = [0.05, 0.10, 0.15]  # 5%, 10%, 15% annual growth
    out_rows = []
    for ticker, row in fundamentals.iterrows():
        base_eps = row.get("trailingEps")
        if base_eps is None or base_eps == 0 or pd.isna(base_eps):
            base_eps = np.nan
        # choose PE multiple preference
        pe = row.get("forwardPE") or row.get("trailingPE") or pe_multiple or np.nan

        for g in growth_rates:
            eps = base_eps
            # project EPS year by year
            for _ in range(years):
                eps = eps * (1 + g) if not pd.isna(eps) else np.nan
            projected_price = eps * pe if not pd.isna(eps) and not pd.isna(pe) else np.nan
            out_rows.append(
                {
                    "ticker": ticker,
                    "growth_rate": g,
                    "years": years,
                    "base_eps": base_eps,
                    "applied_pe": pe,
                    "projected_price": projected_price,
                }
            )
    return pd.DataFrame(out_rows).set_index(["ticker", "growth_rate"])


def save_summary(
    fundamentals: pd.DataFrame,
    scenarios: pd.DataFrame,
    filename_prefix: str = "intel_valuation",
) -> None:
    """Save fundamentals and scenarios to CSV files."""
    fundamentals.to_csv(f"{filename_prefix}_fundamentals.csv")
    scenarios.to_csv(f"{filename_prefix}_scenarios.csv")


def plot_price_histories(tickers: List[str], names: Dict[str, str], period: str = "1y"):
    """Plot price histories for given tickers over period."""
    plt.figure(figsize=(10, 6))
    for tk in tickers:
        hist = fetch_price_history(tk, period=period)
        if hist.empty:
            continue
        # normalize to 100 at start for easier comparison
        start = hist["close"].iloc[0]
        normalized = (hist["close"] / start) * 100
        plt.plot(hist.index, normalized, label=names.get(tk, tk))
    plt.title(f"1Y Price History (normalized to 100)")
    plt.xlabel("Date")
    plt.ylabel("Normalized Price (start=100)")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()


def plot_valuation_bars(fundamentals: pd.DataFrame):
    """Plot bar charts for PER and P/B across tickers."""
    df = fundamentals.copy()
    # prepare data
    per = df["trailingPE"].replace([None], np.nan).astype(float)
    pb = df["priceToBook"].replace([None], np.nan).astype(float)

    fig, axes = plt.subplots(1, 2, figsize=(12, 5))
    per.dropna().plot.bar(ax=axes[0])
    axes[0].set_title("Trailing P/E")
    axes[0].set_ylabel("P/E")
    pb.dropna().plot.bar(ax=axes[1])
    axes[1].set_title("Price / Book")
    axes[1].set_ylabel("P/B")
    plt.tight_layout()
    plt.show()


def main():
    """Main flow: fetch, compute, save, and plot."""
    tickers_map = default_tickers()
    tickers = list(tickers_map.keys())
    print("Fetching fundamentals for:", tickers)
    fundamentals = fetch_fundamentals(tickers)
    print("Fundamentals snapshot:")
    print(fundamentals[["regularMarketPrice", "marketCap", "trailingPE", "priceToBook"]])

    # Price history plot
    print("Plotting 1-year normalized price histories...")
    plot_price_histories(tickers, tickers_map, period="1y")

    # Valuation bars
    print("Plotting valuation (P/E, P/B) comparison...")
    plot_valuation_bars(fundamentals)

    # Scenario projections
    print("Computing simple EPS-growth scenarios (5 years) ...")
    scenarios = compute_simple_scenarios(fundamentals, years=5, growth_rates=[0.05, 0.10, 0.15])
    print(scenarios.head())

    # Save CSVs
    timestamp = datetime.utcnow().strftime("%Y%m%dT%H%MZ")
    prefix = f"intel_valuation_{timestamp}"
    save_summary(fundamentals, scenarios, filename_prefix=prefix)
    print(f"Saved fundamentals and scenarios as CSV with prefix: {prefix}")


if __name__ == "__main__":
    main()
```

사용 팁 / 커스터마이즈

티커 추가/제거: default_tickers() 반환값을 수정하거나 tickers = ["INTC", "AMD", ...]로 직접 지정하세요.

기간 변경: plot_price_histories(..., period="6mo") 등으로 변경 가능. yfinance의 period 인자로 1d,5d,1mo,3mo,6mo,1y,2y,5y,max 등을 사용하세요.

더 깊은 밸류에이션(예: EV/EBITDA, DCF 등)은 추가 데이터(EBITDA, FCF, CapEx 예측 등)가 필요하므로 원하면 확장해 드립니다.

한국 종목의 경우 yfinance 데이터가 완전하지 않을 수 있으니(enterpriseValue 등 일부 필드), 필요하면 한국 전용 데이터 소스(네이버 금융 크롤링, KRX API, 금융투자사 데이터 등)로 보완하는 코드를 추가할 수 있습니다.


원하시면:

위 스크립트를 실행해서 나온 CSV 결과(또는 출력 캡처)를 보내주시면, 제가 결과 해석(PER/PB 비교, 어떤 종목이 싸보이는지 등)을 상세히 도와드리겠습니다.
또는 DCF 템플릿(간단 버전)을 이 코드에 추가해 드릴게요. 어떤 쪽을 먼저 도와드릴까요?


