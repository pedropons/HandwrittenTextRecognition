# Reconocimiento de Texto Escrito

Este trabajo permite cargar una fotografía en la que aparezca algún texto manuscrito y devuelve el mismo texto digitalizado (respetando saltos de línea y palabras separadas). El código se ha generado enteramente en MATLAB.

## crearTrainData.m (script)
Creación del conjunto de características, obtenidas del conjunto de datos EMNIST (emnist-byclass.mat), preparado para entrenar un modelo. Las características utilizadas se extraen de las transformadas de Gabor obtenidas con diversos parámetros. Concretamente, de cada transformada se obtiene su desviación típica y su media.

Utilizando estos datos, puede entrenarse el modelo que se desee. En este caso, el modelo escogido ha sido un SVM cudarático, entrenado fácilmente mediante la toolbox "Classification Learner". El modelo está contenido en "QuadSVM_std_mean.mat".

Si se desea entrenar otro modelo, puede hacerse con las características contenidas en TrainFeatures (el proceso de obtención de características es algo lento).

## textRecognition.m (función)

Función principal que permite la carga de una imagen y devuelve el texto digitalizado. La función llama a otras funciones que se encargan de pasos contretos. La función "preproc" se encarga de preprocesar las imágenes (los pasos están detallados en el archivo "explicacionPreprocesadoImagenes"). "miGabor" obtiene las transformaciones de Gabor, y por último "getText" utiliza las características de Gabor y el modelo preentrenado para predecir el texto escrito.

En el repositorio hay una imagen de prueba, "formularioPrueba", para introducir a esta función.
