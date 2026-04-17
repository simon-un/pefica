# Pautas de contribución

## Flujo de Trabajo GitFlow

Este proyecto adopta el flujo de trabajo **GitFlow** para mantener un proceso de desarrollo organizado y estable. En GitFlow:

- Las ramas `main` y `develop` son ramas permanentes en el repositorio original
- `main`: Contiene el código de producción estable
- `develop`: Contiene el código integrado para el próximo release
- Las funcionalidades nuevas se desarrollan en ramas `feature/*`
- Los arreglos urgentes se desarrollan en ramas `hotfix/*`

### Bienvenida

Primero que todo, muchas gracias por considerar contribuir con aportes valiosos. Estos proyectos se mantienen activos gracias a sus aportes.

### ¿Por qué leer estas pautas? 

Seguir estas directrices nos ayuda a saber que usted respeta el tiempo de los desarrolladores que administran y mantienen este proyecto de software libre. A cambio, los desarrolladores están comprometidos con abordar el problema, evaluar los cambios y ayudarle a finalizar las solicitudes de extracción.


## Reglas generales 

- Utilizar únicamente la rama de desarrollo para proponer cambios o mejoras.
- Garantizar la compatibilidad entre plataformas para cada cambio que se acepte. Windows, Mac, Debian, Ubuntu, Linux en general.
- Asegúrese de que el código que entra en el repositorio cumple con las reglas generales de desarrollo para cada lenguaje de programación.
- Seguir o crear problemas (_issues_) para los cambios y mejoras importantes que desee realizar. 
- Tratar las discusiones de forma transparente y obtener comentarios de la comunidad.
- No agregue ninguna clase al código base a menos que sea absolutamente necesario. Debe limitarse al uso de funciones y nunca usar el paradigma de programación orientado a objetos.
- Mantenga los cambios o cambios de características lo más pequeñas posible.

## Contribuciones menores 

Antes de comenzar directamente con el desarrollo de algunas funcionalidades nuevas, agradeceremos sus aportes con:

- Arreglar un problema (_issue_)
- Revisar discusiones, alguna mejora o un _pull request_ propuesto por otra persona
- Actualizar documentación de las funciones o del programa en general
- Complementar una página web 
- Escribir un tutorial 
- Desarrollar ejemplos de aplicación 

## Colaborar en un proyecto (Flujo GitFlow)

Para desarrollos mayores a simples arreglos de un par de líneas o correcciones tipográficas, siga este flujo de trabajo basado en GitFlow:

### 1. Preparación inicial (una sola vez)
```bash
# Hacer fork del repositorio original en GitHub
# Luego clonar su fork localmente
git clone https://github.com/TU_USUARIO/pefica.git
cd pefica

# Configurar el remoto upstream para mantenerse actualizado
git remote add upstream https://github.com/ORIGINAL_OWNER/pefica.git
```

### 2. Para trabajar en una nueva funcionalidad (feature)
```bash
# Asegurarse de estar actualizado con develop
git fetch upstream
git checkout develop
git merge upstream/develop  # O git pull upstream develop

# Crear rama para la funcionalidad
git checkout -b feature/nombre-de-tu-feature

# Trabajar en su feature...
# (hacer cambios, commits, etc.)

# RECOMENDADO: Actualizar frecuentemente con develop
git fetch upstream
git rebase upstream/develop

# Cuando esté listo para enviar
git push origin feature/nombre-de-tu-feature

# Luego crear un Pull Request desde su fork hacia el repositorio original:
# - Base repository: original/pefica
# - Base branch: develop
# - Head repository: tu-fork/pefica
# - Compare branch: feature/nombre-de-tu-feature
```

### 3. Para hacer un arreglo pequeño o urgente (hotfix)
```bash
# Asegurarse de estar actualizado con main
git fetch upstream
git checkout main
git merge upstream/main  # O git pull upstream main

# Crear rama para el hotfix
git checkout -b hotfix/descripcion-del-arreglo

# Trabajar en su hotfix...
# (hacer cambios, commits, etc.)

# Cuando esté listo para enviar
git push origin hotfix/descripcion-del-arreglo

# Luego crear un Pull Request desde su fork hacia el repositorio original:
# - Base repository: original/pefica
# - Base branch: main (para hotfixes críticos) o develop (para arreglos menores)
# - Head repository: tu-fork/pefica
# - Compare branch: hotfix/descripcion-del-arreglo
```

### 4. Después de que su PR sea aceptado
```bash
# Eliminar la rama local (opcional, pero recomendado)
git branch -d feature/nombre-de-tu-feature
# o
git branch -d hotfix/descripcion-del-arreglo

# Actualizar su fork con los cambios del repositorio original
git fetch upstream
git checkout develop
git merge upstream/develop
git push origin develop

# Para main:
git checkout main
git merge upstream/main
git push origin main
```

## Notas importantes

- **Rebase frecuente**: Al trabajar en una feature, se recomienda hacer rebase de la rama `develop` con frecuencia para estar siempre actualizado y evitar conflictos de integración.
- **Nombre de ramas**: Use nombres descriptivos pero concisos para sus ramas (ej: `feature/login-autenticacion`, `hotfix/correccion-typo-readme`).
- **Commits**: Mantenga los commits atómicos y con mensajes claros siguiendo el formato: `tipo(scope): descripción`.
- **PRs**: Siempre dirija sus Pull Requests hacia la rama `develop` para nuevas funcionalidades y hacia `main` o `develop` para hotfixes, según corresponda.
- **Fork**: Nunca trabaje directamente en el repositorio original; siempre use su fork para crear ramas y enviar PRs.


## Apartado para Administradores: Integración de Hotfix desde Pull Requests Externos

Cuando un desarrollador externo envía un Pull Request con un hotfix hacia `main`, el PR solo hace merge en `main`. El desarrollador no puede hacer merge automático a `develop` desde su fork. 

**Procedimiento para integrar el hotfix en develop manualmente:**

### Opción 1: Desde la interfaz de GitHub
1. Une el PR del hotfix a `main` (merge squash o merge commit según preferencia)
2. Ve a la página del repositorio original
3. Navega a la rama `develop`
4. Haz clic en "Contribute" → "Open pull request"
5. Configura:
   - Base branch: `develop`
   - Compare branch: `main`
6. Crea el PR e integra (merge) los cambios de `main` hacia `develop`
7. Elimina la rama del hotfix si ya no es necesaria

### Opción 2: Desde la línea de comandos
```bash
# En el repositorio local del administrador (clonado desde el repo original)
git fetch origin

# Ir a develop
git checkout develop

# Hacer merge de main a develop
git merge origin/main
# Resolver conflictos si los hay

# Subir los cambios
git push origin develop
```

### Notas
- Es importante que el merge a `develop` se haga **después** de que el PR esté integrado en `main`
- Si hay conflictos, resolvelos localmente y haz el push
- Este proceso asegura que tanto producción (`main`) como desarrollo (`develop`) tengan la corrección


