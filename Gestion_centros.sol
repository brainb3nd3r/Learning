// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;
pragma experimental ABIEncoderV2;

contract OMS_COVID {

    address public OMS;

    constructor (){
        OMS= msg.sender;
    }

    mapping(address => bool) public Validacion_centro_salud;
    mapping (address => address) public CentroSalud_contrato;

    address [] public direcciones_contratos_salud;
    address [] Solicitudes;

    event SolicitudAcceso (address);
    event nuevocentrovalidado (address);
    event nuevo_contrato (address, address);

    modifier Unicamente (address _direccion){
        require (_direccion ==OMS, "No tienes permiso."); 
        _;
    }

    function SolicitarAcceso() public{
        Solicitudes.push(msg.sender);
        emit SolicitudAcceso (msg.sender);
    }

    function VisualizarSolicitudes () public view Unicamente (msg.sender) returns (address[] memory){
        return Solicitudes;
    }


    function nuevoCentroSalud (address _centroSalud) public Unicamente (msg.sender){

        Validacion_centro_salud[_centroSalud]= true;

        emit nuevocentrovalidado (_centroSalud);
    }

    function factoryCentroSalud () public{
        require (Validacion_centro_salud[msg.sender] ==true, "No tienes permiso.");

        address contrato_centrosalud = address (new Centro_Salud (msg.sender));

        direcciones_contratos_salud.push (contrato_centrosalud);

        CentroSalud_contrato [msg.sender] = contrato_centrosalud;
        
        emit nuevo_contrato (contrato_centrosalud, msg.sender);


    }

}

contract Centro_Salud {
    address public DireccionCentroSalud;
    address public Direccioncontrato;

    constructor (address _direccion) public {
        DireccionCentroSalud= _direccion;
        Direccioncontrato= address(this);
    }
}
