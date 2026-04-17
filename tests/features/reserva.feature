# language: es

Característica: Reserva de salas de reunión

  Como empleado de la empresa
  Quiero reservar salas de reunión disponibles
  Para organizar reuniones respetando la capacidad y los horarios disponibles

  Antecedentes:
    Dado que el sistema gestiona las siguientes salas con sus capacidades máximas:
      | sala | capacidad |
      | A    | 4         |
      | B    | 8         |
      | C    | 20        |
    Y que el horario laboral permitido para reservas es de "08:00" a "20:00"

  Escenario: Flujo principal - Crear una reserva válida y consultarla por identificador
    Dado que no existen reservas en el sistema
    Cuando se crea una reserva para la sala "B" el día "2099-06-01" de "10:00" a "11:00" con 5 asistentes y propósito "Revisión semanal del equipo de plataforma"
    Entonces el sistema confirma la creación de la reserva
    Y la reserva aparece al listar las reservas de la sala "B"
    Y es posible consultar los detalles de la reserva por su identificador

  Escenario: Flujo principal - Cancelar una reserva futura
    Dado que existe una reserva para la sala "A" el día "2099-06-01" de "09:00" a "10:00" con 3 asistentes y propósito "Entrevista candidato desarrollador junior"
    Cuando se cancela la reserva
    Entonces el sistema confirma la cancelación
    Y la reserva ya no aparece al listar las reservas de la sala "A"

  Esquema del escenario: Validación - Rechazar reserva cuando los asistentes exceden la capacidad de la sala
    Cuando se intenta crear una reserva para la sala "<sala>" el día "2099-06-01" de "09:00" a "10:00" con <asistentes> asistentes y propósito "Propósito de reunión con más asistentes"
    Entonces el sistema rechaza la reserva por exceder la capacidad de la sala

    Ejemplos:
      | sala | asistentes |
      | A    | 5          |
      | B    | 9          |
      | C    | 21         |

  Esquema del escenario: Validación - Rechazar reserva con horario fuera de las reglas establecidas
    Cuando se intenta crear una reserva para la sala "B" el día "2099-06-01" de "<hora_inicio>" a "<hora_fin>" con 5 asistentes y propósito "Propósito de reunión de prueba de horario"
    Entonces el sistema rechaza la reserva por horario inválido

    Ejemplos:
      | hora_inicio | hora_fin |
      | 11:00       | 10:00    |
      | 07:00       | 09:00    |
      | 18:00       | 21:00    |
      | 09:00       | 09:10    |
      | 09:00       | 14:01    |

  Escenario: Validación - Rechazar reserva con propósito inferior a diez caracteres
    Cuando se intenta crear una reserva para la sala "B" el día "2099-06-01" de "10:00" a "11:00" con 5 asistentes y propósito "Reunión"
    Entonces el sistema rechaza la reserva por propósito inválido

  Escenario: Validación - Rechazar la cancelación de una reserva ya ocurrida
    Dado que existe una reserva para la sala "B" el día "2000-01-01" de "10:00" a "11:00" con 5 asistentes y propósito "Revisión retrospectiva de proyecto ya finalizado"
    Cuando se cancela la reserva
    Entonces el sistema rechaza la cancelación por ser una reserva en fecha pasada

  Escenario: Caso límite - Rechazar reserva que solapa con una existente en la misma sala y día
    Dado que existe una reserva para la sala "B" el día "2099-06-01" de "10:00" a "11:00" con 5 asistentes y propósito "Revisión semanal del equipo de plataforma"
    Cuando se intenta crear una reserva para la sala "B" el día "2099-06-01" de "10:30" a "11:30" con 4 asistentes y propósito "Seguimiento de avance del proyecto"
    Entonces el sistema rechaza la reserva por solapamiento de horario

  Escenario: Seguridad - El sistema almacena propósitos con contenido malicioso como texto plano
    Cuando se crea una reserva para la sala "B" el día "2099-06-01" de "09:00" a "10:00" con 5 asistentes y propósito "Propósito con inyección: ' OR 1=1; DROP TABLE reservas--"
    Entonces el sistema confirma la creación de la reserva
    Y el propósito almacenado es exactamente el texto ingresado sin modificaciones
