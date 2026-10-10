"""문서(HTML)를 화면 그대로 PDF로 저장 (탭 내용 펼침, 정답·타이머 제외 — theme/doc.scss의 @media print 설정 사용)
사용법: quarto render 후  python make_pdf.py   (pip install playwright && playwright install chromium 필요)
브라우저에서 직접 인쇄해도 같은 결과: 문서 열기 → Cmd/Ctrl + P → PDF로 저장 (배경 그래픽 체크)"""
import subprocess, time, pathlib
from playwright.sync_api import sync_playwright

pages = ["d1-01-r-basics", "d1-02-dataframe-1", "d1-03-dataframe-2", "d1-04-dataframe-3",
         "d2-01-descriptive-statistics", "d2-02-ggplot2", "d2-03-linear-regression", "d2-04-sports100-practice"]
root = pathlib.Path(__file__).parent
srv = subprocess.Popen(["python3", "-m", "http.server", "8799", "-d", str(root / "docs")],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(1)
try:
    with sync_playwright() as p:
        b = p.chromium.launch()
        pg = b.new_page()
        for name in pages:
            pg.goto(f"http://localhost:8799/{name}.html", wait_until="load")
            pg.wait_for_timeout(1500)
            pg.pdf(path=str(root / "pdf" / f"{name}.pdf"), format="A4", print_background=True,
                   margin={"top": "14mm", "bottom": "14mm", "left": "12mm", "right": "12mm"},
                   display_header_footer=True, header_template="<span></span>",
                   footer_template='<div style="font-size:8px;width:100%;text-align:center;color:#888">'
                                   '<span class="pageNumber"></span> / <span class="totalPages"></span></div>')
            print("saved", name)
        b.close()
finally:
    srv.terminate()
