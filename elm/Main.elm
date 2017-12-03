module Main exposing (..)

import Task
import Window
import Html exposing (program)
import Maps
import Maps
import Http
import Json.Decode exposing (Decoder, map3, map2, field, string, float, int, list)
import Maps.Geo exposing (latLng)
import Maps.Map as Map
import Maps.Marker as Marker


type alias Parking =
    { coord : ( Float, Float )
    , id : Int
    , name : String
    }


type Msg
    = MapsMsg (Maps.Msg Msg)
    | Resize Window.Size
    | LoadParkings (Result Http.Error (List Parking))
    | Noop


type alias Model =
    { map : Maps.Model Msg
    , parkings : List Parking
    }


parkingsUrl =
    "http://10.20.3.166:3000/parkings"


decodeParking : Decoder Parking
decodeParking =
    map3 Parking
        (map2 (,)
            (field "latitude" float)
            (field "longitude" float)
        )
        (field "id" int)
        (field "name" string)


getParkigns =
    Http.get parkingsUrl (list decodeParking)


initModel =
    { map =
        Maps.defaultModel
            |> Maps.updateMap (Map.setZoom 14 >> Map.moveTo userLocation)
    , parkings =
        [ { name = "Estacionamento", coord = ( -22.8928607, -43.2957455 ), id = 1 }
        ]
    }


defaultSize =
    Window.Size 500 500


startCmds =
    [ Task.attempt (Result.withDefault defaultSize >> Resize) Window.size
    , Http.send LoadParkings getParkigns
    ]


init =
    initModel ! startCmds


view model =
    Html.map MapsMsg <| Maps.view model.map


subscriptions model =
    Sub.batch
        [ Sub.map MapsMsg <| Maps.subscriptions model.map
        , Window.resizes Resize
        ]


main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


update msg model =
    case msg of
        MapsMsg mmsg ->
            model.map
                |> Maps.update mmsg
                |> Tuple.mapFirst (\map -> { model | map = map })
                |> Tuple.mapSecond (Cmd.map MapsMsg)

        Resize size ->
            model.map
                |> Maps.updateMap (Map.setWidth <| toFloat size.width)
                |> Maps.updateMap (Map.setHeight <| toFloat size.height)
                |> (\map -> { model | map = map } ! [])

        LoadParkings (Ok parkings) ->
            { model
                | parkings = parkings
                , map =
                    model.map
                        |> Maps.updateMarkers
                            (\markers ->
                                List.map
                                    Marker.create
                                    (parkings
                                        |> List.map (\p -> uncurry latLng p.coord)
                                    )
                            )
            }
                ! []

        --
        _ ->
            model ! []


userLocation =
    Maps.Geo.latLng -22.8944452 -43.2943711


attractions =
    List.map (uncurry Maps.Geo.latLng)
        [ ( -22.8944452, -43.2943711 )
        , ( -22.89278, -43.2931798 )
        , ( -22.8928607, -43.2957455 )
        ]
