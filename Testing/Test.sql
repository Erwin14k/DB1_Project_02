-- ########################### INGRESAR Restaurante ###########################
CALL RegistrarRestaurante('R-01', 'Zona 10, Guatemala City','Guatemala',-10,12121212,10,1); -- Zona invalida
CALL RegistrarRestaurante('R-01', 'Zona 10, Guatemala City','Guatemala',10,12121212,-10,1); -- personal invalido
CALL RegistrarRestaurante('R-01', 'Zona 10, Guatemala City','Guatemala',10,12121212,10,1); -- ok
CALL RegistrarRestaurante('R-01', 'Zona 10, Guatemala City','Guatemala',10,12121212,10,1); -- error duplicado



-- ########################### INGRESAR Puesto De Trabajo ###########################
CALL RegistrarPuesto('Gerente','Monitoreo del restaurante',-5000.00); -- Salario Invalido
CALL RegistrarPuesto('Gerente','Monitoreo del restaurante',5000.00);  -- ok
CALL RegistrarPuesto('Gerente','Monitoreo del restaurante',5000.00); -- Error repetido
CALL RegistrarPuesto('Mesero','Servir la comida',3500.00); -- ok
CALL RegistrarPuesto('Repartidor','Llevar pedidos a domicilio',3900.00); -- ok


-- ########################### INGRESAR Empleados ###########################
CALL CrearEmpleado('Harry','Maguire','1990-01-01','hola.com',12347890,'Zona 15',4567098710234,
'2022-01-01',1,"R-01"); -- Correo invalido
CALL CrearEmpleado('Harry','Maguire','1990-01-01','hola@gmail.com',12347890,'Zona 15',4567098710234,
'2022-01-01',4,"R-01"); -- Error, puesto de trabajo inexistente
CALL CrearEmpleado('Harry','Maguire','1990-01-01','hola@gmail.com',12347890,'Zona 15',4567098710234,
'2022-01-01',1,"R-02"); -- Error, restaurante inexistente
CALL CrearEmpleado('Harry','Maguire','1990-01-01','hola@gmail.com',12347890,'Zona 15',4567098710234,
'2022-01-01',1,"R-01"); -- Ok
CALL CrearEmpleado('James','Hollywood','1990-01-01','aaa@hotmail.es',12347899,'Zona 15',4567098710234,
'2022-01-01',1,"R-01"); -- Error, dpi duplicado
CALL CrearEmpleado('James','Hollywood','1990-01-01','aaa@hotmail.es',12347899,'Zona 15',4567098710235,
'2022-01-01',3,"R-01"); -- Ok


-- ########################### INGRESAR Clientes ###########################
CALL RegistrarCliente(1234678909123,'Alex','Hunter','1990-01-01','bbbbb@',89709867,NULL); -- Correo Invalido
CALL RegistrarCliente(1234678909123,'Alex','Hunter','1990-01-01','bbbbb@gmail.com',89709867,NULL); -- ok
CALL RegistrarCliente(1234678909123,'Calvin','Murder','1990-01-01','ccccc@gmail.com',89709867,NULL); -- Error, Dpi duplicado
CALL RegistrarCliente(1234678909097,'Calvin','Murder','1990-01-01','ccccc@gmail.com',89709867,89765678); -- ok


-- ########################### INGRESAR Direcciones ###########################

CALL RegistrarDireccion(4444444444444,'Zona 24, Guatemala','Guatemala',10); -- Error, dpi inexistente
CALL RegistrarDireccion(1234678909123,'Zona 24, Guatemala','Guatemala',10); -- ok
CALL RegistrarDireccion(1234678909123,'Zona 6, Mixco','Mixco',-1); -- Error, zona inválida
CALL RegistrarDireccion(1234678909097,'Zona 6, Mixco','Mixco',6); -- ok
CALL RegistrarDireccion(1234678909097,'Zona 10, Guatemala','Guatemala',10); -- ok


-- ########################### Crear Ordenes ###########################
CALL CrearOrden(4444444444444,1,'L'); -- Error, dpi inexistente
CALL CrearOrden(1234678909123,2,'L'); -- Error, dpi si existe, pero esa direccion es de otro cliente
CALL CrearOrden(1234678909123,1,'L'); -- ok
CALL CrearOrden(1234678909097,2,'C'); -- Error canal equivocado
CALL CrearOrden(1234678909097,2,'A'); -- Error, no hay restaurante con cobertura
CALL CrearOrden(1234678909097,3,'A'); -- ok


-- ########################### Agregar Items a ordenes ###########################
CALL AgregarItem(10,'C',1,10,''); -- Error, orden inexistente
CALL AgregarItem(1,'C',1,-10,''); -- Error, cantidad invalida
CALL AgregarItem(1,'O',1,10,''); -- Error, tipo de producto invalido
CALL AgregarItem(1,'C',10,10,''); -- Error, producto inexistente
CALL AgregarItem(1,'C',1,10,''); -- ok
CALL AgregarItem(1,'E',1,10,''); -- ok
CALL AgregarItem(1,'B',1,10,''); -- ok
CALL AgregarItem(1,'P',1,10,''); -- ok
CALL AgregarItem(1,'P',19,10,''); -- Error, producto inexistente
CALL AgregarItem(2,'P',19,10,''); -- Error, no se pueden agregar items a una orden sin cobertura
CALL AgregarItem(2,'C',2,5,''); -- ok
CALL AgregarItem(2,'E',2,5,''); -- ok
CALL AgregarItem(2,'B',2,5,''); -- ok
CALL AgregarItem(2,'P',2,5,''); -- ok


-- ########################### Confirmar ordenes ###########################
CALL ConfirmarOrden(10,'E',3); -- Error,Orden inexistente
CALL ConfirmarOrden(1,'E',13); -- Error, El trabajador no existe
CALL ConfirmarOrden(1,'S',2); -- Error, Método de pago invalido
CALL ConfirmarOrden(1,'E',2); -- ok
CALL ConfirmarOrden(3,'T',2); -- ok


-- ########################### Finalizar Órdenes ###########################
CALL FinalizarOrden(1); -- OK
CALL FinalizarOrden(10); -- Error, orden inexistente
CALL FinalizarOrden(2); -- OK


-- ########################### REPORTE # 01 ###########################
CALL ListarRestaurantes();

-- ########################### REPORTE # 02 ###########################
CALL ConsultarEmpleado(5); -- Error Empleado inexistente
CALL ConsultarEmpleado(1); -- ok
CALL ConsultarEmpleado(2); -- ok
CALL ConsultarEmpleado(4); -- Error Empleado inexistente

-- ########################### REPORTE # 03 ###########################
CALL ConsultarPedidosCliente(1); -- ok
CALL ConsultarPedidosCliente(2); -- Error, esta orden se quedo en estado de "SIN COBERTURA"
CALL ConsultarPedidosCliente(3); -- ok
CALL ConsultarPedidosCliente(4); -- Error, esta orden no existe

-- ########################### REPORTE # 04 ###########################
CALL ConsultarHistorialOrdenes(1234678909123); -- ok
CALL ConsultarHistorialOrdenes(44444444444444); -- Error, dpi inexistente
CALL ConsultarHistorialOrdenes(1234678909097); -- ok

-- ########################### REPORTE # 05 ###########################
CALL ConsultarDirecciones(1234678909123); --ok
CALL ConsultarDirecciones(44444444444444); -- Error, dpi inexistente
CALL ConsultarDirecciones(1234678909097); -- ok

-- ########################### REPORTE # 06 ###########################
CALL MostrarOrdenes(-1); -- Debería mostrar una orden sin cobertura
CALL MostrarOrdenes(1); -- No debería mostrar nada
CALL MostrarOrdenes(2); -- No debería mostrar nada
CALL MostrarOrdenes(3); -- No debería mostrar nada
CALL MostrarOrdenes(4); -- Debería mostrar 2 órdenes entregadas.

-- ########################### REPORTE # 07 ###########################
-- Editar las fechas según sea el caso de validación
CALL ConsultarFacturas(19,04,2023);
CALL ConsultarFacturas(29,04,2023);

-- ########################### REPORTE # 08 ###########################
-- Editar los minutos de parametro segun sea el caso de validación
CALL ConsultarTiempos(3);
CALL ConsultarTiempos(10);
CALL ConsultarTiempos(1);