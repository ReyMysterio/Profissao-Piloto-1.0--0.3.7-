#include <a_samp>
#include <ZCMD>

//Dialog
#define DIALOG_PILOTO				6000

//Cores
#define VERMELHO					0xFF0000FF
#define C_PILOTO					0x7FFFD4FF

new
	String[128],
	ViagemPiloto[MAX_PLAYERS],
	PessoasPiloto[MAX_PLAYERS],
	TimerPilotoLV[MAX_PLAYERS],
	TimerPilotoSF[MAX_PLAYERS],
	DecolouPiloto[MAX_PLAYERS]
;

public OnFilterScriptInit()
{
	CreateVehicle(519, 1559.5100, -2458.6501, 15.0139, 180.0000, -1, -1, 180);
	CreateVehicle(519, 1643.5100, -2458.6501, 15.0139, 180.0000, -1, -1, 180);
	CreateVehicle(519, 1728.5100, -2458.6501, 15.0139, 180.0000, -1, -1, 180);
	CreateVehicle(519, 1516.8866, 1486.3162, 12.7049, 90.0000, -1, -1, 180);
	CreateVehicle(519, 1516.8768, 187.3682, 12.7049, 90.0000, -1, -1, 180);
	CreateVehicle(519, 1516.8866, 1456.3162, 12.7049, 90.0000, -1, -1, 180);
	CreateVehicle(519, 1516.8866, 1426.3162, 12.7049, 90.0000, -1, -1, 180);
	CreateVehicle(519, -1368.6406, -224.2166, 16.3174, 316.5527, -1, -1, 180);
	CreateVehicle(519, -1336.6191, -255.1735, 16.3174, 316.5527, -1, -1, 180);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	ViagemPiloto[playerid] = 0;
	PessoasPiloto[playerid] = 0;
	DecolouPiloto[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	KillTimer(TimerPilotoLV[playerid]);
	KillTimer(TimerPilotoSF[playerid]);
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(DecolouPiloto[playerid] == 1)
	{
		TogglePlayerControllable(playerid, 0);
		GameTextForPlayer(playerid, "~r~Descarregando Passageiros Aguarde...", 15000, 3);
		SetTimerEx("DescongelarPlayerPilotoLV", 15000, false, "i", playerid);
		return 1;
	}
	if(DecolouPiloto[playerid] == 2)
	{
		TogglePlayerControllable(playerid, 0);
		GameTextForPlayer(playerid, "~r~Descarregando Passageiros Aguarde...", 15000, 3);
		SetTimerEx("DescongelarPlayerPilotoSF", 15000, false, "i", playerid);
		return 1;
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_PILOTO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					TogglePlayerControllable(playerid, 0);
					SendClientMessage(playerid, C_PILOTO, "Você iniciou uma viagem para Las Venturas!");
					SendClientMessage(playerid, C_PILOTO, "Cada pessoa entra a cada 5 segundos e tem o valor de {00FF00}R$100{7FFFD4}!");
					SendClientMessage(playerid, C_PILOTO, "Se quiser decolar digite {FF0000}/Decolagem{7FFFD4}.");
					ViagemPiloto[playerid] = 1;
					PessoasPiloto[playerid] = 0;
					TimerPilotoLV[playerid] = SetTimerEx("CarregarPessoasLV", 5000, true, "i", playerid);
					return 1;
				}
				case 1:
				{
					TogglePlayerControllable(playerid, 0);
					SendClientMessage(playerid, C_PILOTO, "Você iniciou uma viagem para San Fierro!");
					SendClientMessage(playerid, C_PILOTO, "Cada pessoa entra a cada 10 segundos e tem o valor de {00FF00}R$150{7FFFD4}!");
					SendClientMessage(playerid, C_PILOTO, "Se quiser decolar antes digite {FF0000}/Decolagem{7FFFD4}.");
					ViagemPiloto[playerid] = 2;
					PessoasPiloto[playerid] = 0;
					TimerPilotoSF[playerid] = SetTimerEx("CarregarPessoasSF", 10000, true, "id", playerid);
					return 1;
				}
			}
		}
	}
	return 1;
}

CMD:iniciarviagem(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 519)
		{
			if(IsPlayerInRangeOfPoint(playerid, 20.0, 1559.4946, -2458.6296, 14.5024) || IsPlayerInRangeOfPoint(playerid, 20.0, 1643.5100, -2458.6340, 14.4952) || IsPlayerInRangeOfPoint(playerid, 20.0, 1728.5100, -2458.6340, 14.4952))
			{
				if (ViagemPiloto[playerid] == 0)
				{
					new StringCat[128];
					strcat(StringCat, "Destino\tValor\n");
					strcat(StringCat, "{FFFFFF}Las Venturas {D2691E} \t{FFFFFF}Até {00FF00}R$1000\n");
					strcat(StringCat, "{FFFFFF}San Fierro {D2691E} \t{FFFFFF}Até {00FF00}R$1500");
					ShowPlayerDialog(playerid, DIALOG_PILOTO, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Viagens", StringCat, "Continuar", "Cancelar");
					return 1;
				}
				else SendClientMessage(playerid, VERMELHO, "Você já iniciou uma viagem!");
				return 1;
			}
			else SendClientMessage(playerid, VERMELHO, "Você não está no Aeroporto de LS no spawn dos aviões de Piloto!");
			return 1;
		}
		else SendClientMessage(playerid, VERMELHO, "Você não está em um veículo ( Shamal )!");
		return 1;
	}
	else SendClientMessage(playerid, VERMELHO, "Você não está dirigindo!");
	return 1;
}

CMD:decolagem(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 519)
		{
			if (IsPlayerInRangeOfPoint(playerid, 20.0, 1559.4946, -2458.6296, 14.5024) || IsPlayerInRangeOfPoint(playerid, 20.0, 1643.5100, -2458.6340, 14.4952) || IsPlayerInRangeOfPoint(playerid, 20.0, 1728.5100, -2458.6340, 14.4952))
			{
				if(PessoasPiloto[playerid] > 0)
				{
					if(ViagemPiloto[playerid] == 0)
					{
						SendClientMessage(playerid, VERMELHO, "Você não iniciou uma viagem!");
						return 1;
					}
					if(ViagemPiloto[playerid] == 1)
					{
						TogglePlayerControllable(playerid, 1);
						DisablePlayerRaceCheckpoint(playerid);
						SetPlayerRaceCheckpoint(playerid, 1, 1571.2466, 1509.7697, 10.8355, 0.0, 0.0, 0.0, 10.0);
						format(String, sizeof(String), "Você inicou a viagem! Foram carregadas {00FF00}%d {7FFFD4}pessoa(s).", PessoasPiloto[playerid]);
						SendClientMessage(playerid, C_PILOTO, String);
						SendClientMessage(playerid, C_PILOTO, "Vá até ao aeroporto de Las Venturas e descarregue os passageiros no checkpoint.");
						KillTimer(TimerPilotoLV[playerid]);
						DecolouPiloto[playerid] = 1;
					}
					if(ViagemPiloto[playerid] == 2)
					{
						TogglePlayerControllable(playerid, 1);
						DisablePlayerRaceCheckpoint(playerid);
						SetPlayerRaceCheckpoint(playerid, 1, -1348.9656, -234.0063, 14.1484, 0.0, 0.0, 0.0, 10.0);
						format(String, sizeof(String), "Você inicou a viagem! Foram carregadas {00FF00}%d {7FFFD4}pessoa(s).", PessoasPiloto[playerid]);
						SendClientMessage(playerid, C_PILOTO, String);
						SendClientMessage(playerid, C_PILOTO, "Vá até ao aeroporto de San Fierro e descarregue os passageiros no checkpoint.");
						KillTimer(TimerPilotoSF[playerid]);
						DecolouPiloto[playerid] = 2;
					}
				}
				else SendClientMessage(playerid, VERMELHO, "Você não tem pessoas para decolar!");
				return 1;
			}
			else SendClientMessage(playerid, VERMELHO, "Você não está no Aeroporto de LS no spawn dos aviões de Piloto!");
			return 1;
		}
		else SendClientMessage(playerid, VERMELHO, "Você não está em um veículo ( Shamal )!");
		return 1;
	}
	else SendClientMessage(playerid, VERMELHO, "Você não está dirigindo!");
	return 1;
}

forward CarregarPessoasLV(playerid);
public CarregarPessoasLV(playerid)
{
	PessoasPiloto[playerid]++;
	format(String, sizeof(String), "Entrou %d pessoa(s)!", PessoasPiloto[playerid]);
	SendClientMessage(playerid, C_PILOTO, String);
	if(PessoasPiloto[playerid] >= 10)
	{
		TogglePlayerControllable(playerid, 1);
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 1, 1571.2466, 1509.7697, 10.8355, 0.0, 0.0, 0.0, 10.0);
		SendClientMessage(playerid, C_PILOTO, "O avião ficou lotado! Vá até ao aeroporto de Las Venturas e descarregue os passageiros no checkpoint.");
		DecolouPiloto[playerid] = 1;
		KillTimer(TimerPilotoLV[playerid]);
		return 1;
	}
	return 1;
}

forward CarregarPessoasSF(playerid);
public CarregarPessoasSF(playerid)
{
	PessoasPiloto[playerid]++;
	format(String, sizeof(String), "Entrou %d pessoa(s)!", PessoasPiloto[playerid]);
	SendClientMessage(playerid, C_PILOTO, String);
	if(PessoasPiloto[playerid] >= 10)
	{
		TogglePlayerControllable(playerid, 1);
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 1, -1348.9656, -234.0063, 14.1484, 0.0, 0.0, 0.0, 10.0);
		SendClientMessage(playerid, C_PILOTO, "O avião ficou lotado! Vá até ao aeroporto de San Fierro e descarregue os passageiros no checkpoint.");
		DecolouPiloto[playerid] = 2;
		KillTimer(TimerPilotoSF[playerid]);
		return 1;
	}
	return 1;
}

forward DescongelarPlayerPilotoLV(playerid);
public DescongelarPlayerPilotoLV(playerid)
{
	TogglePlayerControllable(playerid, 1);
	DisablePlayerRaceCheckpoint(playerid);
	format(String, sizeof(String), "Foi descarregado %d pessoa(s) e você ganhou R$%d!", PessoasPiloto[playerid], PessoasPiloto[playerid]*100);
	SendClientMessage(playerid, C_PILOTO, String);
	GivePlayerMoney(playerid, PessoasPiloto[playerid]*100);
	ViagemPiloto[playerid] = 0;
	DecolouPiloto[playerid] = 0;
	return 1;
}

forward DescongelarPlayerPilotoSF(playerid);
public DescongelarPlayerPilotoSF(playerid)
{
	TogglePlayerControllable(playerid, 1);
	DisablePlayerRaceCheckpoint(playerid);
	format(String, sizeof(String), "Foi descarregado %d pessoa(s) e você ganhou R$%d!", PessoasPiloto[playerid], PessoasPiloto[playerid]*150);
	SendClientMessage(playerid, C_PILOTO, String);
	GivePlayerMoney(playerid, PessoasPiloto[playerid]*150);
	ViagemPiloto[playerid] = 0;
	DecolouPiloto[playerid] = 0;
	return 1;
}