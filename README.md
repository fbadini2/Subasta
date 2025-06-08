# Subasta
Smart contract written for the Ethereum blockchain, implementing an online public auction

Este contrato implementa una subasta simple pero completa utilizando Solidity. Soporta ofertas múltiples, extensión de tiempo automática, gestión de comisiones, reembolsos y más.

## Características principales

- Subasta con límite de tiempo ajustable.
- Cada nueva oferta extiende el tiempo restante 10 minutos.
- Registro de todas las ofertas y postores.
- Reembolso automático a los postores no ganadores con comisión del 2%.
- Eventos para notificar a los usuarios en tiempo real.
- Acceso seguro mediante modificadores (`soloPropietario`, `subastaActiva`, etc.).
- Función para que el propietario retire comisiones acumuladas.

---

## Estructura del contrato

### Variables clave
- `propietario`: dirección que despliega la subasta.
- `mejorPostor` y `mejorOferta`: oferta ganadora.
- `finalizada`: indica si la subasta ha concluido.
- `ofertasTotales`: mapping de cada postor con su mejor oferta.
- `devoluciones`: reembolsos pendientes para cada postor.
- `totalComisiones`: acumulado de comisiones del 2%.

### Eventos
- `NuevaOferta`: cuando alguien supera la oferta actual.
- `SubastaFinalizada`: cuando termina la subasta y se declara ganador.
- `FondosRetirados`: cuando un postor retira su reembolso.
- `ComisionesRetiradas`: cuando el propietario cobra sus comisiones.

### Modificadores
- `soloPropietario`: restringe acceso al creador del contrato.
- `subastaActiva`: asegura que la subasta aún está abierta.
- `subastaFinalizada`: restringe funciones hasta que la subasta haya concluido.
- `antesDelFin`: valida que no se ha vencido el tiempo.

---

## ⚙️ Uso en Remix

1. Abre [Remix](https://remix.ethereum.org)
2. Crea un archivo `Subasta.sol` y pega el contrato.
3. Compílalo usando la versión `^0.8.0`.
4. Despliega el contrato desde la pestaña "Deploy & Run":
   - Ingresa duración inicial (en segundos) como parámetro constructor.
5. Simula diferentes postores usando las cuentas disponibles.
6. Llama a `finalizarSubasta()` para terminar la subasta y distribuir fondos.
7. Cada postor no ganador puede llamar a `retirar()` para recibir su dinero.


## 📄 Licencia

Este proyecto se publica bajo la licencia MIT. Puedes usar, modificar o distribuir este contrato libremente, dando crédito adecuado al autor original.

---

## ✍️ Autor

Desarrollado con fines educativos y experimentales por [Tu Nombre o Alias].

