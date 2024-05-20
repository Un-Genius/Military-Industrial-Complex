/// @description LOAD MUSIC ON ARRAY

//put as many musics as you like here

playlistA[0] = music1;
//playlistA[1] = music1;
//playlistA[2] = music1;
//playlistA[3] = music1;


playlistB[0] = music2;
//playlistB[1] = music1;
//playlistB[2] = music1;
//playlistB[3] = music1;

//add your alternative rooms here
lstAltRooms = ds_list_create();
ds_list_add(lstAltRooms, roomMenuPlay);


roomType = "PLAY_A"; //PLAY_A, PLAY_B

alarm[0] = 1;
playingNow = -1;
musicVolume = 1;

