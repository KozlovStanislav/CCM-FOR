# CCM-FOR
Корреляционно-кластерные методы выделения функционально-однородных регионов головного мозга

Основные рабочие версии находятся в папке 'main', новые наработки находятся в папке 'in dev'

Полное описание работы методов см. в статье "Kozlov, Stanislav & Poyda, Alexey & Orlov, Vyacheslav & Malakhov, Denis & Ushakov, Vadim & Sharaev, Maxim. (2020). Selection of functionally homogeneous brain regions based on correlation-clustering analysis. Procedia Computer Science. 169. 519-526. 10.1016/j.procs.2020.02.215."

## Метод функциональной сегментации

Находится в папке main/FSM, основной скрипт: GetCorrelationRegions.m

Запускается через MATLAB. Необходим пакет NIFTI для работы с nii файлами https://mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image

### Входные данные:
   1. NII файл с основными данными в виде X*Y*Z*T, где X,Y,Z - координаты в пространстве, T - временные отчеты, в ячейках матрицы - значени активности в определенном вокселе в определенный момент времени
   2. NII файл с маской вокселей, которые берутся в анализ

### Параметры:
   1. CORR_CUTOFF - отсечка, по которой выделяются границы регионов по корреляции
   2. MIN_REG_SIZE - минимальный размер выделяемого региона в вокселях

### Вывод скрипта:
   newMap - переменная в окружении MATLAB размера X,Y,Z - координаты в пространстве, в ячейках - номера новых регионов

### Как запускать:
   1. В папке FSM открыть скрипт GetCorrelationRegions.m, задать пути к входным данным (PATH_TO_4D_DATA, PATH_TO_MASK), и параметры метода. Мы советуем следующие параметры:
      * CORR_CUTOFF - от 0.7 до 0.85
      * MIN_REG_SIZE - 10 (вокселей)
   2. Закомментировать (если не нужно) удаление автокорреляции
   3. Добавить папку 'source' в path. Также необходимо проверить, что подключен пакет NIfTI
   4. Запустить скрипт
   5. После окончания работы скрипта в окружении MATLAB появится переменная newMap. Эта переменная соодержит 3D матрицу размерности X,Y,Z - координаты в пространстве, в ячейках - номера новых регионов 


## Метод кластеризационной сегментации

Находится в папке main/CSM, основной скрипт: GetStabilityRegions.m

Запускается через MATLAB. Необходим пакет NIFTI для работы с nii файлами https://mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image

### Входные данные:
   1. NII файл с основными данными в виде X*Y*Z*T, где X,Y,Z - координаты в пространстве, T - временные отчеты, в ячейках матрицы - значени активности в определенном вокселе в определенный момент времени
   2. NII файл с картой анатомических регионов, которые берутся в анализ

### Параметры:
   1. WINDOW - размер временного окна
   2. STEP - шаг временного окна
   3. NOT_IN_REG_COUNT - процент от количества окон, в которых воксель может отклониться от своего региона
   4. MIN_REG_SIZE - минимальный размер выделяемого региона в вокселях

### Вывод:
   newMap - переменная в окружении MATLAB размера X,Y,Z - координаты в пространстве, в ячейках - номера новых регионов

### Как запускать:
   1. В папке CSM открыть скрипт GetStabilityRegions.m, задать пути к входным данным (PATH_TO_4D_DATA, PATH_TO_MAP), и параметры метода. Мы советуем следующие параметры:
      * WINDOW - от 100 до 300 временных отчётов (у нас были данные: 1 отчёт = 2 секундам, всего 1000 временных отчётов);
      * STEP - мы рассматриваем шаг размером 50 % от размера окна (половинное перекрытие);
      * NOT_IN_REG_COUNT - от 0 до 0.3
      * MIN_REG_SIZE - 10 (вокселей)
   2. Закомментировать (если не нужно) удаление автокорреляции. Стоит заметить, что текущая функция удаления автокорреляции уменьшает временной ряд на 2 точки. Это стоит учесть в параметре WINDOW
   3. Добавить папку 'source' в path. Также необходимо проверить, что подключен пакет NIfTI
   4. Запустить скрипт
   5. После окончания работы скрипта в окружении MATLAB появится переменная newMap. Эта переменная соодержит 3D матрицу размерности X,Y,Z - координаты в пространстве, в ячейках - номера новых регионов 
   
   
   
   
# CCM-FOR
Correlation-clustering methods of selection of Functionally Homogeneous Human Brain Regions (FHR)

Major working versions are located in the folder 'main', new developments are in the folder 'in dev'

For a full description of how the methods work, see the article "Kozlov, Stanislav & Poyda, Alexey & Orlov, Vyacheslav & Malakhov, Denis & Ushakov, Vadim & Sharaev, Maxim. (2020). Selection of functionally homogeneous brain regions based on correlation-clustering analysis. Procedia Computer Science. 169. 519-526. 10.1016/j.procs.2020.02.215."

## Functional Segmentation Method

Located in the folder main/FSM, main script: GetCorrelationRegions.m

Runs through MATLAB. NIFTI package required to work with nii files https://mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image 

### Input data:
   1. NII file with main data in the form of X*Y*Z*T, where X, Y, Z are coordinates in space, T is coordinate in time, matrix values - the values of activity in a certain voxel at a certain point in time
   2. NII file with a mask of voxels that are taken for analysis

### Options:
   1. CORR_CUTOFF - cutoff by which the boundaries of regions are distinguished by correlation
   2. MIN_REG_SIZE - minimum size of the selected region in voxels

### Script output:
   newMap - variable in MATLAB environment of size X, Y, Z - coordinates in space, matrix values - numbers of new regions

### How to run:
   1. Open the GetCorrelationRegions.m script in the FSM folder, set the paths to the input data (PATH_TO_4D_DATA, PATH_TO_MASK), and the method parameters. We recommend the following options:
      * CORR_CUTOFF - from 0.7 to 0.85
      * MIN_REG_SIZE - 10 (voxels)
   2. Comment out (if not needed) removing autocorrelation
   3. Add the 'source' folder to path.  It is also necessary to check that MATLAB has a NIFTI package
   4. Run the script
   5. After the script finishes, the variable "newMap" appears in the MATLAB environment. This variable contains a 3D matrix of dimensions X, Y, Z - coordinates in space, matrix values - numbers of new regions


## Clustering Segmentation Method

Located in the folder main/CSM, main script: GetStabilityRegions.m

Runs through MATLAB. NIFTI package required to work with nii files https://mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image 

### Input data:
   1. NII file with main data in the form of X*Y*Z*T, where X, Y, Z are coordinates in space, T is coordinate in time, matrix values - the values of activity in a certain voxel at a certain point in time
   2. NII file with a map of anatomical regions that are taken for analysis

### Options:
   1. WINDOW - time window size
   2. STEP - time window step
   3. NOT_IN_REG_COUNT - percentage of the number of windows in which the voxel can deviate from its region
   4. MIN_REG_SIZE - the minimum size of the selected region in voxels

### Script output:
   newMap - variable in MATLAB environment of size X, Y, Z - coordinates in space, matrix values - numbers of new regions

### Как запускать:
   1. Open the GetStabilityRegions.m script in the CSM folder, set the paths to the input data (PATH_TO_4D_DATA, PATH_TO_MASK), and the method parameters. We recommend the following options:
      * WINDOW - from 100 to 300 time points (we test it on data where: 1 time point = 2 seconds and there is 1000 time points);
      * STEP - 50% of the window size (half overlap);
      * NOT_IN_REG_COUNT - from 0 to 0.3
      * MIN_REG_SIZE - 10 (voxels)
   2. Comment out (if not needed) the autocorrelation removal. It is worth noting that the current autocorrelation removal function reduces the time series by 2 points. This should be taken into account in the parameter "WINDOW"
   3. Add the 'source' folder to path. It is also necessary to check that MATLAB has a NIFTI package
   4. Run the script
   5. After the script finishes, the variable "newMap" appears in the MATLAB environment. This variable contains a 3D matrix of dimensions X, Y, Z - coordinates in space, matrix values - numbers of new regions
   
   

   
