# Clustered-nuclei-splitting-with-recurrent-distance-transform

### Description
The accuracy of the applied technique for automated nuclei segmentation is critical in obtaining high-quality and efficient diagnostic results. Unfortunately, multiple objects in histopathological images are connected (clustered) and frequently counted as one. In this study, we present a new method for cluster splitting based on distance transform binarized with the recurrently increased threshold value and modified watershed algorithm. The proposed method treats clusters separately, splitting them into smaller sub-clusters and conclusively into separate objects, based solely on the shape feature, making it independent of the pixel intensity. The efficiency of these algorithms is validated based on the labeled set of images from two datasets: BBBC004v1 and breast cancer tissue microarrays. Results of initial nuclei detection were significantly improved by applying the proposed algorithms. Our approach outperformed the state-of-the-art techniques based on recall, precision, F1-score, and Jaccard index. The proposed method achieves very low amount of under-segmented, as well as over-segmented objects. In summary, we provide novel and efficient method for dividing the clustered nuclei in digital images of histopathological slides.

![13640_2020_514_Fig3_HTML](https://github.com/knave88/Clustered-nuclei-splitting-with-recurrent-distance-transform/blob/main/13640_2020_514_Fig3_HTML.png)

### Publication
Roszkowiak, L., Korzynska, A., Pijanowska, D. et al. Clustered nuclei splitting based on recurrent distance transform in digital pathology images. J Image Video Proc., 26, 2020. (published: 01 July 2020)

DOI: https://doi.org/10.1186/s13640-020-00514-6

****
### Acknowledgement
The related study was conducted in Laboratory of Processing and Analysis of Microscopic Images (head: D.Sc. Anna Korzynska) in Nalecz Institute of Biocybernetics and Biomedical Engineering Polish Academy of Sciences.

We acknowledge the financial support of the Polish National Science Center grant, PRELUDIUM, 2013/11/N/ST7/02797. The funders had no role in study design, data collection and analysis, or preparation of the software.

We would like to thank the Molecular Biology and Research Section, Hospital de Tortosa Verge de la Cinta, Institut d’Investigaci Sanitria Pere Virgili (IISPV), URV, Spain, and Pathology Department of the same hospital for their cooperation and generous sharing of samples.

### Liability
We do not take any responsibility and we are not liable for any damage caused through use of this software, be it indirect, special, incidental or consequential damages.
