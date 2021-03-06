% ------------------------------------------------------------------------------
% PEFICA-Octave Archivo de datos de entrada
% para solo un tipo de elemento finito
% ------------------------------------------------------------------------------
% datos generales
NELE = 309;    % número de elementos
NNUD = 182;    % número de nudos
NNUE = 3;    % número máximo de nudos por elemento
NGAU = 1;    % número máximo de puntos de Gauss por elemento
NDIM = 2;    % número de dimensiones
NCAT = 1;    % número de categorias de elementos
TIPR = 20;   % código del tipo de problema:
             % 20: plano de esfuerzos, 21: plano de deformaciones
ENNU = 0;    % tipo de evaluación de esfuerzos/deformaciones en el elemento
             % 0: eval en PG, 1: eval en los nudos, 2: eval en centro del elemen
IMPR = 2;    % tipo de impresión de los resultados
             % 0: ninguno, 1: en ventana de comandos, 2: en GiD, 3: en VC y GiD

% tabla de categoría y conectividades de los elementos: ELE()
% incluye: categoría ICAT, primer nudo NUDI, segundo nudo NUDJ, tercer nudo NUDK
% ELE = [ ICAT NUDI NUDJ NUDK ] % IELE
ELE = [ ...
      1     182      181      180   ;  %      1  
      1     181      177      174   ;  %      2  
      1     177      170      164   ;  %      3  
      1       1        2        3   ;  %      4  
      1      17       25       24   ;  %      5  
      1     178      175      166   ;  %      6  
      1     167      165      151   ;  %      7  
      1       5       11        8   ;  %      8  
      1      34       45       47   ;  %      9  
      1     172      169      157   ;  %     10  
      1       2        5        4   ;  %     11  
      1      25       34       33   ;  %     12  
      1     175      172      161   ;  %     13  
      1     165      163      147   ;  %     14  
      1      11       17       15   ;  %     15  
      1     179      178      171   ;  %     16  
      1     169      167      153   ;  %     17  
      1      56       66       60   ;  %     18  
      1      76       89       81   ;  %     19  
      1     103      118      111   ;  %     20  
      1     134      150      142   ;  %     21  
      1      66       76       70   ;  %     22  
      1      89      103       95   ;  %     23  
      1     118      134      126   ;  %     24  
      1     174      177      164   ;  %     25  
      1     174      164      160   ;  %     26  
      1     181      174      180   ;  %     27  
      1     164      170      154   ;  %     28  
      1     160      164      145   ;  %     29  
      1     174      160      173   ;  %     30  
      1      24       25       33   ;  %     31  
      1      24       33       30   ;  %     32  
      1     157      169      153   ;  %     33  
      1     157      153      141   ;  %     34  
      1      15       17       24   ;  %     35  
      1      15       24       21   ;  %     36  
      1      30       33       39   ;  %     37  
      1     141      153      138   ;  %     38  
      1      21       24       30   ;  %     39  
      1      21       30       28   ;  %     40  
      1      28       30       41   ;  %     41  
      1      21       28       20   ;  %     42  
      1     151      165      147   ;  %     43  
      1      33       34       47   ;  %     44  
      1     166      175      161   ;  %     45  
      1     166      161      149   ;  %     46  
      1     149      161      144   ;  %     47  
      1     166      149      156   ;  %     48  
      1       4        5        8   ;  %     49  
      1       4        8        9   ;  %     50  
      1       9        8       13   ;  %     51  
      1       4        9        6   ;  %     52  
      1     153      167      151   ;  %     53  
      1     153      151      138   ;  %     54  
      1     138      151      137   ;  %     55  
      1       8       11       15   ;  %     56  
      1       8       15       13   ;  %     57  
      1      13       15       21   ;  %     58  
      1      13       21       20   ;  %     59  
      1      13       20       14   ;  %     60  
      1      14       20       23   ;  %     61  
      1      13       14        9   ;  %     62  
      1       9       14       10   ;  %     63  
      1      10       14       18   ;  %     64  
      1       9       10        6   ;  %     65  
      1       6       10        7   ;  %     66  
      1     161      172      157   ;  %     67  
      1     161      157      144   ;  %     68  
      1     144      157      141   ;  %     69  
      1     144      141      128   ;  %     70  
      1     128      141      124   ;  %     71  
      1     144      128      133   ;  %     72  
      1     178      166      171   ;  %     73  
      1       2        4        3   ;  %     74  
      1     137      151      147   ;  %     75  
      1     138      137      122   ;  %     76  
      1      60       66       70   ;  %     77  
      1      60       70       67   ;  %     78  
      1     111      118      126   ;  %     79  
      1     111      126      119   ;  %     80  
      1      70       76       81   ;  %     81  
      1      70       81       78   ;  %     82  
      1     126      134      142   ;  %     83  
      1     126      142      135   ;  %     84  
      1      67       70       78   ;  %     85  
      1      67       78       75   ;  %     86  
      1     119      126      135   ;  %     87  
      1     119      135      129   ;  %     88  
      1      78       81       90   ;  %     89  
      1     135      142      152   ;  %     90  
      1      75       78       87   ;  %     91  
      1     129      135      146   ;  %     92  
      1      81       89       95   ;  %     93  
      1      81       95       90   ;  %     94  
      1      90       95      104   ;  %     95  
      1     142      150      158   ;  %     96  
      1     142      158      152   ;  %     97  
      1     152      158      168   ;  %     98  
      1     152      168      162   ;  %     99  
      1     162      168      176   ;  %    100  
      1     152      162      146   ;  %    101  
      1     146      162      160   ;  %    102  
      1     162      176      173   ;  %    103  
      1     173      176      180   ;  %    104  
      1     162      173      160   ;  %    105  
      1     173      180      174   ;  %    106  
      1     152      146      135   ;  %    107  
      1      95      103      111   ;  %    108  
      1      95      111      104   ;  %    109  
      1     104      111      119   ;  %    110  
      1     104      119      113   ;  %    111  
      1     113      119      129   ;  %    112  
      1     104      113       98   ;  %    113  
      1     113      129      125   ;  %    114  
      1      56       60       50   ;  %    115  
      1      60       67       57   ;  %    116  
      1      67       75       63   ;  %    117  
      1     154      170      159   ;  %    118  
      1     154      159      143   ;  %    119  
      1     164      154      145   ;  %    120  
      1     145      154      136   ;  %    121  
      1      90      104       98   ;  %    122  
      1      90       98       87   ;  %    123  
      1      87       98       96   ;  %    124  
      1      96       98      109   ;  %    125  
      1      87       96       82   ;  %    126  
      1      90       87       78   ;  %    127  
      1     136      154      143   ;  %    128  
      1     136      143      127   ;  %    129  
      1     127      143      132   ;  %    130  
      1     136      127      120   ;  %    131  
      1     145      136      125   ;  %    132  
      1     160      145      146   ;  %    133  
      1     132      143      148   ;  %    134  
      1     132      148      139   ;  %    135  
      1     127      132      116   ;  %    136  
      1     120      127      110   ;  %    137  
      1     136      120      125   ;  %    138  
      1     125      120      109   ;  %    139  
      1     125      109      113   ;  %    140  
      1     113      109       98   ;  %    141  
      1      18       14       23   ;  %    142  
      1      18       23       26   ;  %    143  
      1      26       23       31   ;  %    144  
      1      18       26       22   ;  %    145  
      1      10       18       16   ;  %    146  
      1     143      159      148   ;  %    147  
      1      96      109      110   ;  %    148  
      1      82       96       93   ;  %    149  
      1      87       82       75   ;  %    150  
      1      31       23       29   ;  %    151  
      1      26       31       35   ;  %    152  
      1      22       26       32   ;  %    153  
      1      18       22       16   ;  %    154  
      1      16       22       19   ;  %    155  
      1     124      141      138   ;  %    156  
      1     124      138      122   ;  %    157  
      1     128      124      112   ;  %    158  
      1     133      128      117   ;  %    159  
      1     144      133      149   ;  %    160  
      1     149      133      140   ;  %    161  
      1     140      133      123   ;  %    162  
      1     149      140      156   ;  %    163  
      1     156      140      155   ;  %    164  
      1     124      122      108   ;  %    165  
      1     123      133      117   ;  %    166  
      1     123      117      106   ;  %    167  
      1     106      117      102   ;  %    168  
      1     123      106      115   ;  %    169  
      1     140      123      131   ;  %    170  
      1     102      117      112   ;  %    171  
      1     102      112       97   ;  %    172  
      1     106      102       92   ;  %    173  
      1     115      106      100   ;  %    174  
      1     123      115      131   ;  %    175  
      1     131      115      121   ;  %    176  
      1     121      115      105   ;  %    177  
      1     131      121      139   ;  %    178  
      1     131      139      155   ;  %    179  
      1     139      121      132   ;  %    180  
      1      23       20       29   ;  %    181  
      1      29       20       28   ;  %    182  
      1      29       28       36   ;  %    183  
      1      36       28       41   ;  %    184  
      1      29       36       37   ;  %    185  
      1     105      115      100   ;  %    186  
      1     105      100       91   ;  %    187  
      1      91      100       85   ;  %    188  
      1     105       91      101   ;  %    189  
      1     121      105      116   ;  %    190  
      1     121      116      132   ;  %    191  
      1      39       33       47   ;  %    192  
      1      41       30       39   ;  %    193  
      1      41       39       53   ;  %    194  
      1     122      130      114   ;  %    195  
      1     166      156      171   ;  %    196  
      1       4        6        3   ;  %    197  
      1      85      100       92   ;  %    198  
      1      85       92       80   ;  %    199  
      1      91       85       79   ;  %    200  
      1     101       91       86   ;  %    201  
      1     105      101      116   ;  %    202  
      1      56       50       41   ;  %    203  
      1      63       75       74   ;  %    204  
      1      29       37       31   ;  %    205  
      1      31       37       42   ;  %    206  
      1      42       37       49   ;  %    207  
      1      31       42       35   ;  %    208  
      1      35       42       48   ;  %    209  
      1      48       42       54   ;  %    210  
      1      35       48       43   ;  %    211  
      1      49       37       44   ;  %    212  
      1      42       49       54   ;  %    213  
      1      54       49       63   ;  %    214  
      1      48       54       59   ;  %    215  
      1      43       48       55   ;  %    216  
      1      35       43       32   ;  %    217  
      1      32       43       40   ;  %    218  
      1      40       43       52   ;  %    219  
      1      32       40       27   ;  %    220  
      1      50       60       57   ;  %    221  
      1      50       57       44   ;  %    222  
      1      44       57       49   ;  %    223  
      1      50       44       36   ;  %    224  
      1      36       44       37   ;  %    225  
      1      57       67       63   ;  %    226  
      1      57       63       49   ;  %    227  
      1     110      127      116   ;  %    228  
      1     120      110      109   ;  %    229  
      1     125      129      145   ;  %    230  
      1     145      129      146   ;  %    231  
      1      10       16       12   ;  %    232  
      1      12       16       19   ;  %    233  
      1      93       96      110   ;  %    234  
      1      97      112      108   ;  %    235  
      1     108      112      124   ;  %    236  
      1      48       59       55   ;  %    237  
      1      32       26       35   ;  %    238  
      1      59       54       65   ;  %    239  
      1      43       55       52   ;  %    240  
      1      52       55       61   ;  %    241  
      1      61       55       64   ;  %    242  
      1      52       61       58   ;  %    243  
      1      64       55       59   ;  %    244  
      1      61       64       71   ;  %    245  
      1      58       61       69   ;  %    246  
      1      52       58       46   ;  %    247  
      1      82       93       86   ;  %    248  
      1      86       93      101   ;  %    249  
      1     101       93      110   ;  %    250  
      1     102       97       88   ;  %    251  
      1      22       32       27   ;  %    252  
      1     117      128      112   ;  %    253  
      1     108      122      107   ;  %    254  
      1      85       80       73   ;  %    255  
      1      80       92       88   ;  %    256  
      1      88       92      102   ;  %    257  
      1      80       88       71   ;  %    258  
      1      80       71       64   ;  %    259  
      1     140      131      155   ;  %    260  
      1      40       52       46   ;  %    261  
      1      40       46       38   ;  %    262  
      1      61       71       69   ;  %    263  
      1     100      106       92   ;  %    264  
      1      58       69       68   ;  %    265  
      1      46       58       51   ;  %    266  
      1      79       85       73   ;  %    267  
      1      79       73       65   ;  %    268  
      1      86       91       79   ;  %    269  
      1      74       75       82   ;  %    270  
      1      63       74       65   ;  %    271  
      1      65       54       63   ;  %    272  
      1      88       97       83   ;  %    273  
      1     107      122      114   ;  %    274  
      1     107      114       99   ;  %    275  
      1      73       80       64   ;  %    276  
      1      73       64       59   ;  %    277  
      1      59       65       73   ;  %    278  
      1     108      107       94   ;  %    279  
      1      68       69       77   ;  %    280  
      1      83       97       94   ;  %    281  
      1      94      107       99   ;  %    282  
      1      77       69       83   ;  %    283  
      1      77       83       94   ;  %    284  
      1      68       77       72   ;  %    285  
      1      68       72       62   ;  %    286  
      1      68       62       58   ;  %    287  
      1      88       83       71   ;  %    288  
      1     108       94       97   ;  %    289  
      1      62       51       58   ;  %    290  
      1      46       51       38   ;  %    291  
      1      84       72       77   ;  %    292  
      1       7        3        6   ;  %    293  
      1       7       10       12   ;  %    294  
      1     147      130      137   ;  %    295  
      1     137      130      122   ;  %    296  
      1      38       27       40   ;  %    297  
      1      99       84       94   ;  %    298  
      1      27       19       22   ;  %    299  
      1      86       79       74   ;  %    300  
      1     156      155      171   ;  %    301  
      1      53       39       47   ;  %    302  
      1      69       71       83   ;  %    303  
      1      74       82       86   ;  %    304  
      1     101      110      116   ;  %    305  
      1      36       41       50   ;  %    306  
      1      65       74       79   ;  %    307  
      1      53       56       41   ;  %    308  
      1      84       77       94   ]; %    309  

% tabla de coordenadas de los nudos: XYZ()
% incluye: coord. x: XNUD, coord. y: YNUD
% XYZ = [ XNUD YNUD ] % INUD
XYZ = [ ...
   +0.000000e+00     +0.000000e+00  ;  % 1
   +5.714286e-02     +0.000000e+00  ;  % 2
   +0.000000e+00     +6.000000e-02  ;  % 3
   +8.571429e-02     +5.196152e-02  ;  % 4
   +1.142857e-01     +0.000000e+00  ;  % 5
   +5.446774e-02     +1.029785e-01  ;  % 6
   +0.000000e+00     +1.200000e-01  ;  % 7
   +1.428571e-01     +5.196152e-02  ;  % 8
   +1.142857e-01     +1.039230e-01  ;  % 9
   +6.671800e-02     +1.517607e-01  ;  % 10
   +1.714286e-01     +0.000000e+00  ;  % 11
   +0.000000e+00     +1.800000e-01  ;  % 12
   +1.741037e-01     +1.029785e-01  ;  % 13
   +1.382744e-01     +1.501598e-01  ;  % 14
   +2.000000e-01     +5.196152e-02  ;  % 15
   +5.005704e-02     +2.027415e-01  ;  % 16
   +2.285714e-01     +0.000000e+00  ;  % 17
   +1.099411e-01     +2.025220e-01  ;  % 18
   +0.000000e+00     +2.400000e-01  ;  % 19
   +1.973249e-01     +1.549401e-01  ;  % 20
   +2.285714e-01     +1.039230e-01  ;  % 21
   +6.611157e-02     +2.509589e-01  ;  % 22
   +1.636070e-01     +2.043420e-01  ;  % 23
   +2.571429e-01     +5.196152e-02  ;  % 24
   +2.857143e-01     +0.000000e+00  ;  % 25
   +1.350128e-01     +2.553637e-01  ;  % 26
   +0.000000e+00     +3.000000e-01  ;  % 27
   +2.571429e-01     +1.558846e-01  ;  % 28
   +2.234926e-01     +2.027565e-01  ;  % 29
   +2.857143e-01     +1.039230e-01  ;  % 30
   +1.946383e-01     +2.552563e-01  ;  % 31
   +1.016585e-01     +3.051260e-01  ;  % 32
   +3.194935e-01     +5.425496e-02  ;  % 33
   +3.428571e-01     +0.000000e+00  ;  % 34
   +1.649191e-01     +3.072714e-01  ;  % 35
   +2.825279e-01     +2.096240e-01  ;  % 36
   +2.470061e-01     +2.578037e-01  ;  % 37
   +0.000000e+00     +3.600000e-01  ;  % 38
   +3.455323e-01     +1.029785e-01  ;  % 39
   +6.369405e-02     +3.550654e-01  ;  % 40
   +3.312243e-01     +1.621088e-01  ;  % 41
   +2.182975e-01     +3.084302e-01  ;  % 42
   +1.309767e-01     +3.562722e-01  ;  % 43
   +3.068779e-01     +2.563633e-01  ;  % 44
   +4.000000e-01     +0.000000e+00  ;  % 45
   +4.818895e-02     +4.006272e-01  ;  % 46
   +4.000000e-01     +6.666667e-02  ;  % 47
   +1.904806e-01     +3.598001e-01  ;  % 48
   +2.778518e-01     +3.087483e-01  ;  % 49
   +3.476529e-01     +2.290181e-01  ;  % 50
   +0.000000e+00     +4.200000e-01  ;  % 51
   +1.013401e-01     +4.083672e-01  ;  % 52
   +4.000000e-01     +1.333333e-01  ;  % 53
   +2.500816e-01     +3.588577e-01  ;  % 54
   +1.576533e-01     +4.099066e-01  ;  % 55
   +4.000000e-01     +2.000000e-01  ;  % 56
   +3.468728e-01     +2.884191e-01  ;  % 57
   +6.836737e-02     +4.582285e-01  ;  % 58
   +2.211026e-01     +4.112839e-01  ;  % 59
   +3.992199e-01     +2.594010e-01  ;  % 60
   +1.280768e-01     +4.610790e-01  ;  % 61
   +0.000000e+00     +4.800000e-01  ;  % 62
   +3.282104e-01     +3.530026e-01  ;  % 63
   +1.878529e-01     +4.614947e-01  ;  % 64
   +2.787971e-01     +4.177730e-01  ;  % 65
   +4.500000e-01     +2.285714e-01  ;  % 66
   +3.984397e-01     +3.188019e-01  ;  % 67
   +4.547166e-02     +5.103548e-01  ;  % 68
   +9.574427e-02     +5.115562e-01  ;  % 69
   +4.492199e-01     +2.879724e-01  ;  % 70
   +1.576035e-01     +5.132471e-01  ;  % 71
   +0.000000e+00     +5.400000e-01  ;  % 72
   +2.349484e-01     +4.871940e-01  ;  % 73
   +3.419494e-01     +4.277573e-01  ;  % 74
   +3.976596e-01     +3.782029e-01  ;  % 75
   +5.000000e-01     +2.571429e-01  ;  % 76
   +6.324663e-02     +5.619892e-01  ;  % 77
   +4.484397e-01     +3.473733e-01  ;  % 78
   +2.992262e-01     +4.839027e-01  ;  % 79
   +2.028979e-01     +5.378922e-01  ;  % 80
   +4.992199e-01     +3.165438e-01  ;  % 81
   +3.997933e-01     +4.393149e-01  ;  % 82
   +1.139044e-01     +5.865650e-01  ;  % 83
   +0.000000e+00     +6.000000e-01  ;  % 84
   +2.627661e-01     +5.403327e-01  ;  % 85
   +3.542949e-01     +4.897306e-01  ;  % 86
   +4.500157e-01     +4.072046e-01  ;  % 87
   +1.738278e-01     +5.894806e-01  ;  % 88
   +5.500000e-01     +2.857143e-01  ;  % 89
   +5.007959e-01     +3.763751e-01  ;  % 90
   +3.226015e-01     +5.406287e-01  ;  % 91
   +2.309706e-01     +5.908269e-01  ;  % 92
   +4.037037e-01     +4.990899e-01  ;  % 93
   +7.882403e-02     +6.422227e-01  ;  % 94
   +5.492199e-01     +3.451152e-01  ;  % 95
   +4.533268e-01     +4.655356e-01  ;  % 96
   +1.413590e-01     +6.399087e-01  ;  % 97
   +4.988353e-01     +4.288962e-01  ;  % 98
   +0.000000e+00     +6.600000e-01  ;  % 99
   +2.929213e-01     +5.920146e-01  ;  % 100
   +3.824019e-01     +5.426936e-01  ;  % 101
   +2.011939e-01     +6.428502e-01  ;  % 102
   +6.000000e-01     +3.142857e-01  ;  % 103
   +5.531895e-01     +4.044006e-01  ;  % 104
   +3.502312e-01     +5.931456e-01  ;  % 105
   +2.609624e-01     +6.427265e-01  ;  % 106
   +4.950810e-02     +6.945674e-01  ;  % 107
   +1.094829e-01     +6.937924e-01  ;  % 108
   +5.086672e-01     +4.876899e-01  ;  % 109
   +4.461704e-01     +5.460292e-01  ;  % 110
   +5.992199e-01     +3.736867e-01  ;  % 111
   +1.690155e-01     +6.930499e-01  ;  % 112
   +5.479928e-01     +4.626297e-01  ;  % 113
   +0.000000e+00     +7.200000e-01  ;  % 114
   +3.206821e-01     +6.451409e-01  ;  % 115
   +4.139225e-01     +6.025039e-01  ;  % 116
   +2.318800e-01     +6.941400e-01  ;  % 117
   +6.500000e-01     +3.428571e-01  ;  % 118
   +5.984397e-01     +4.330876e-01  ;  % 119
   +5.059482e-01     +5.492444e-01  ;  % 120
   +3.798990e-01     +6.450732e-01  ;  % 121
   +6.611847e-02     +7.471156e-01  ;  % 122
   +2.880527e-01     +6.952169e-01  ;  % 123
   +1.398993e-01     +7.454175e-01  ;  % 124
   +5.477893e-01     +5.285735e-01  ;  % 125
   +6.492199e-01     +4.022581e-01  ;  % 126
   +4.736949e-01     +5.991905e-01  ;  % 127
   +1.995634e-01     +7.445955e-01  ;  % 128
   +5.976596e-01     +4.924886e-01  ;  % 129
   +0.000000e+00     +7.800000e-01  ;  % 130
   +3.511118e-01     +6.998272e-01  ;  % 131
   +4.470723e-01     +6.523517e-01  ;  % 132
   +2.591631e-01     +7.474856e-01  ;  % 133
   +7.000000e-01     +3.714286e-01  ;  % 134
   +6.484397e-01     +4.616590e-01  ;  % 135
   +5.324171e-01     +5.919691e-01  ;  % 136
   +5.232838e-02     +7.990107e-01  ;  % 137
   +1.116106e-01     +7.970215e-01  ;  % 138
   +4.000000e-01     +7.000000e-01  ;  % 139
   +3.180370e-01     +7.468655e-01  ;  % 140
   +1.714286e-01     +7.960770e-01  ;  % 141
   +6.992199e-01     +4.308295e-01  ;  % 142
   +5.062783e-01     +6.469172e-01  ;  % 143
   +2.258963e-01     +7.970215e-01  ;  % 144
   +5.951098e-01     +5.763926e-01  ;  % 145
   +6.484652e-01     +5.278788e-01  ;  % 146
   +0.000000e+00     +8.400000e-01  ;  % 147
   +4.666667e-01     +7.000000e-01  ;  % 148
   +2.857143e-01     +7.960770e-01  ;  % 149
   +7.500000e-01     +4.000000e-01  ;  % 150
   +8.571429e-02     +8.480385e-01  ;  % 151
   +7.007959e-01     +4.906608e-01  ;  % 152
   +1.428571e-01     +8.480385e-01  ;  % 153
   +5.656819e-01     +6.514962e-01  ;  % 154
   +4.000000e-01     +7.666667e-01  ;  % 155
   +3.455323e-01     +7.970215e-01  ;  % 156
   +2.000000e-01     +8.480385e-01  ;  % 157
   +7.500000e-01     +4.600000e-01  ;  % 158
   +5.333333e-01     +7.000000e-01  ;  % 159
   +6.500000e-01     +5.961116e-01  ;  % 160
   +2.571429e-01     +8.480385e-01  ;  % 161
   +6.987863e-01     +5.499602e-01  ;  % 162
   +0.000000e+00     +9.000000e-01  ;  % 163
   +6.250000e-01     +6.480731e-01  ;  % 164
   +5.714286e-02     +9.000000e-01  ;  % 165
   +3.194935e-01     +8.457450e-01  ;  % 166
   +1.142857e-01     +9.000000e-01  ;  % 167
   +7.500000e-01     +5.200000e-01  ;  % 168
   +1.714286e-01     +9.000000e-01  ;  % 169
   +6.000000e-01     +7.000000e-01  ;  % 170
   +4.000000e-01     +8.333333e-01  ;  % 171
   +2.285714e-01     +9.000000e-01  ;  % 172
   +7.093239e-01     +5.995642e-01  ;  % 173
   +6.750000e-01     +6.480731e-01  ;  % 174
   +2.857143e-01     +9.000000e-01  ;  % 175
   +7.500000e-01     +5.800000e-01  ;  % 176
   +6.500000e-01     +7.000000e-01  ;  % 177
   +3.428571e-01     +9.000000e-01  ;  % 178
   +4.000000e-01     +9.000000e-01  ;  % 179
   +7.500000e-01     +6.400000e-01  ;  % 180
   +7.000000e-01     +7.000000e-01  ;  % 181
   +7.500000e-01     +7.000000e-01  ]; % 182

% tabla de categorias de los elementos: CAT()
% incluye tipos de material y tipo de elemento
% propiedades del material: módulo de Young :EYOU, relación de Poisson: POIS,
%                           peso específico GAMM.
% propiedades del elemento: espesor: TESP,
%                           tipo: TIPE, num. nudos: NUEL, puntos Gauss: PGAU
% CAT = [ EYOU POIS GAMM TESP TIPE NUEL PGAU ] % ICAT
CAT = [ ...
  +2.0000e+07   +2.5000e-01   +0.0000e+00   +4.0000e-01  201      3 1 ]; % 1

% tabla de desplazamientos conocidos: UCO()
% incluye número del nudo INUD, indicador si el desplazamiento es conocido o no,
% y valor del desplazamiento conocido.
% Indicador del desplazamiento en x: DCUX, vale 0:desconocido 1:conocido;
% indicador del desplazamiento en y: DCUY, vale 0:desconocido 1:conocido;
% valor del desplazamiento conocido en x: VAUX,
% valor del desplazamiento conocido en y: VAUY.
% VAUX no será leida si el desplazamiento es desconocido, es decir DCUX=0,
% VAUY no será leida si el desplazamiento es desconocido, es decir DCUY=0.
% UCO = [ INUD DCUX DCUY VAUX VAUY ]
UCO = [ ...
    1  1  1  0.000000  0.000000 ;...
    2  1  1  0.000000  0.000000 ;...
    5  1  1  0.000000  0.000000 ;...
   11  1  1  0.000000  0.000000 ;...
   17  1  1  0.000000  0.000000 ;...
   25  1  1  0.000000  0.000000 ;...
   34  1  1  0.000000  0.000000 ;...
   45  1  1  0.000000  0.000000 ;...
  163  1  1  0.000000  0.000000 ;...
  165  1  1  0.000000  0.000000 ;...
  167  1  1  0.000000  0.000000 ;...
  169  1  1  0.000000  0.000000 ;...
  172  1  1  0.000000  0.000000 ;...
  175  1  1  0.000000  0.000000 ;...
  178  1  1  0.000000  0.000000 ;...
  179  1  1  0.000000  0.000000 ;...
];

% tabla de fuerzas aplicadas en los nudos de la malla. Incluye número del
% nudo INUD, valor de la fuerza en dirección x FUNX y valor de la fuerza
% en dirección y FUNY.
% FUN = [ INUD FUNX FUNY ]
FUN = zeros(1,3); % No hay fuerzas aplicadas en los nudos

% tabla de fuerzas uniformes distribuidas que se aplican en las caras
% de los elementos. Incluye número del elemento IELE, número de los nudos
% inicial y final de la cara cargada NUDI y NUDJ, valor de la presión en
% dirección x y en dirección y, PREX y PREY, y indicador del sistema
% coordenado de la carga GLOC: =0: global, =1: local.
% FDI = [ IELE NUDI NUDJ PREX PREY GLOC
FDI = [ ...
     2     181     177   +0.0000e+00   -2.5000e+03 0 ;...
     3     177     170   +0.0000e+00   -2.5000e+03 0 ;...
];



