CREATE PROCEDURE [trains].[AlignDataFromTln]
AS
    BEGIN
        BEGIN TRY

            BEGIN TRANSACTION;

            INSERT INTO trains.[TrainStations] ( LegacyStationId ,
                                                 LegacyStationCode ,
                                                 [Description] ,
                                                 [WithdrawalCardStation] ,
                                                 [LoadStation] ,
                                                 [Valid] ,
                                                 Mxp ,
                                                 [NFPVersion] )
                        SELECT [IDStazione] ,
                               [CodiceStazione] ,
                               [NomeStazione] ,
                               [RitiroTessera] ,
                               [RiCaricaAbbonamento] ,
                               1 ,
                               0 ,
                               [Versione]
                        FROM   [tln].[vol_StazioneSbme]
                        WHERE  IDStazione NOT IN (   SELECT LegacyStationId
                                                     FROM   trains.TrainStations );

            PRINT '1. Inserimento nuove stazioni';

            UPDATE trains.TrainStations
            SET    Valid = 0
            WHERE  LegacyStationId NOT IN (   SELECT [IDStazione]
                                              FROM   [tln].[vol_StazioneSbme] );

            PRINT '2. Invalidamento stazioni';

            UPDATE trains.TrainStations
            SET    LegacyStationCode = a.cs ,
                   [Description] = a.ns ,
                   [WithdrawalCardStation] = a.rt ,
                   [LoadStation] = a.rca ,
                   [Valid] = 1 ,
                   NFPVersion = a.vrs
            FROM   (   SELECT [IDStazione] AS ids ,
                              [CodiceStazione] AS cs ,
                              [NomeStazione] AS ns ,
                              [RitiroTessera] AS rt ,
                              [RiCaricaAbbonamento] AS rca ,
                              [Versione] AS vrs
                       FROM   [tln].[vol_StazioneSbme] ) AS a
            WHERE  LegacyStationId = a.ids;

            PRINT '3. Aggiornamento stazioni';

            COMMIT TRANSACTION;

        END TRY
        BEGIN CATCH

            ROLLBACK TRANSACTION;

        END CATCH;

        BEGIN TRY

            BEGIN TRANSACTION;

            INSERT INTO trains.[TrainPaths] ( LegacyPathId ,
                                              SubnetId ,
                                              DepartureStationId ,
                                              ArrivalStationId ,
                                              ViaStaionId1 ,
                                              ViaStaionId2 ,
                                              DistanceKm ,
                                              Valid ,
                                              [NFPVersion] )
                        SELECT [IdPercorso] ,
                               [IdSottorete] ,
                               ts1.TrainStationId ,
                               ts2.TrainStationId ,
                               [IdVia1] ,
                               [IdVia2] ,
                               [Distanza] ,
                               1 ,
                               [Versione]
                        FROM   [tln].[vol_Percorso] AS vo
                               INNER JOIN trains.TrainStations AS ts1 ON ts1.LegacyStationId = vo.[IdStazioneOrigine]
                               INNER JOIN trains.TrainStations AS ts2 ON ts2.LegacyStationId = vo.[IdStazioneDestinazione]
                        WHERE  [IdPercorso] NOT IN (   SELECT LegacyPathId
                                                       FROM   trains.[TrainPaths] );

            PRINT '4. Inserimento nuovi percorsi';

            UPDATE trains.[TrainPaths]
            SET    Valid = 0
            WHERE  LegacyPathId NOT IN (   SELECT [IdPercorso]
                                           FROM   [tln].[vol_Percorso] );

            PRINT '5. Invalidamento percorsi';

            UPDATE trains.[TrainPaths]
            SET    SubnetId = a.ids ,
                   DepartureStationId = a.iso ,
                   ArrivalStationId = a.isd ,
                   ViaStaionId1 = a.idv1 ,
                   ViaStaionId2 = a.idv2 ,
                   DistanceKm = a.dkm ,
                   Valid = 1 ,
                   NFPVersion = a.vrs
            FROM   (   SELECT vo.[IdPercorso] AS idp ,
                              vo.[IdSottorete] AS ids ,
                              ts1.TrainStationId AS iso ,
                              ts2.TrainStationId AS isd ,
                              vo.[IdVia1] AS idv1 ,
                              vo.[IdVia2] AS idv2 ,
                              vo.[Distanza] AS dkm ,
                              vo.[Versione] AS vrs
                       FROM   [tln].[vol_Percorso] AS vo
                              INNER JOIN trains.TrainStations AS ts1 ON ts1.LegacyStationId = vo.[IdStazioneOrigine]
                              INNER JOIN trains.TrainStations AS ts2 ON ts2.LegacyStationId = vo.[IdStazioneDestinazione] ) AS a
            WHERE  LegacyPathId = a.idp;

            PRINT '6. Aggiornamento percorsi';

            COMMIT TRANSACTION;

        END TRY
        BEGIN CATCH

            ROLLBACK TRANSACTION;

        END CATCH;

        BEGIN TRY

            BEGIN TRANSACTION;

            INSERT INTO [dbo].[CardProfiles] ( [CardProfileId] ,
                                               [Description] ,
                                               [Price] ,
                                               [Valid] ,
                                               [ProfileRule] ,
                                               [NFPVersion] )
                        SELECT [CodiceRichiestaProfilo] ,
                               [Descrizione] ,
                               [Prezzo] ,
                               1 ,
                               [RegolaProfilo] ,
                               [Versione]
                        FROM   [tln].[vol_CodiceRichiestaProfilo]
                        WHERE  [CodiceRichiestaProfilo] NOT IN (   SELECT [CardProfileId]
                                                                   FROM   [CardProfiles] );

            PRINT '7. Inserimento nuovi profili tessera';

            UPDATE dbo.[CardProfiles]
            SET    Valid = 0
            WHERE  [CardProfileId] NOT IN (   SELECT [CodiceRichiestaProfilo]
                                              FROM   [tln].[vol_CodiceRichiestaProfilo] );

            PRINT '8. Invalidamento profili tessera';

            UPDATE dbo.[CardProfiles]
            SET    [Description] = a.ds ,
                   [Price] = a.pr ,
                   [Valid] = 1 ,
                   [ProfileRule] = a.rp ,
                   [NFPVersion] = a.vrs
            FROM   (   SELECT [CodiceRichiestaProfilo] AS crp ,
                              [Descrizione] AS ds ,
                              [Prezzo] / 100.0 AS pr ,
                              [Versione] AS vrs ,
                              [RegolaProfilo] AS rp
                       FROM   [tln].[vol_CodiceRichiestaProfilo] ) AS a
            WHERE  [CardProfileId] = a.crp;

            PRINT '9. Aggiornamento profili tessera';

            COMMIT TRANSACTION;

        END TRY
        BEGIN CATCH

            ROLLBACK TRANSACTION;

        END CATCH;
    END;