//
//  CyclesViewModel.swift
//  CalendarApp
//
//  Created by Klesya on 5/14/25.
//

import Foundation
import SwiftUICore

class CyclesViewModel: ObservableObject {
    @Published var cycles: [Cycle] = []
    
    init() {
        self.cycles = [
            Cycle(
                name: "Lunaire",
                duration: 29,
                texts: [
                    Paragraph(title: "🌑 Nouvelle Lune", text: "La Lune se trouve entre la Terre et le Soleil. Sa face éclairée est tournée vers le Soleil, donc on ne la voit pas depuis la Terre. C'est une période idéale pour les nouveaux départs."),
                    Paragraph(title: "🌒 Premier Croissant", text: "Une fine courbe lumineuse apparaît sur le bord droit de la Lune. Chaque nuit, la surface éclairée grandit. Cette phase symbolise la mise en action et la croissance."),
                    Paragraph(title: "🌓 Premier Quartier", text: "La moitié droite de la Lune est éclairée. La Lune est à 90° du Soleil par rapport à la Terre. C'est une période de décisions et d'engagements."),
                    Paragraph(title: "🌔 Gibbeuse Croissante", text: "Plus de la moitié de la Lune est visible. Elle continue de croître en direction de la pleine lune. C’est une phase d’élan, de clarté et de progrès."),
                    Paragraph(title: "🌕 Pleine Lune", text: "La face visible de la Lune est entièrement éclairée. La Terre se trouve entre le Soleil et la Lune. C'est une phase de culmination, d’intensité émotionnelle et de libération."),
                    Paragraph(title: "🌖 Gibbeuse Décroissante", text: "La lumière commence à diminuer. La Lune perd progressivement son éclat. C’est une période d’analyse, de gratitude et de recentrage."),
                    Paragraph(title: "🌗 Dernier Quartier", text: "La moitié gauche de la Lune est éclairée. La Lune continue de décroître. Cette phase invite à la réflexion, au tri et à la réorganisation."),
                    Paragraph(title: "🌘 Dernier Croissant", text: "Il ne reste qu’un mince filet lumineux sur le bord gauche. C’est un moment d’introspection, de repos et de préparation pour un nouveau cycle."),
                    Paragraph(title: "⏳ Durée du cycle", text: "Le cycle lunaire dure environ 29,5 jours, de nouvelle lune à nouvelle lune. On parle de cycle synodique."),
                    Paragraph(title: "🔄 Mécanisme du cycle", text: "Les phases lunaires sont dues à la position relative de la Lune, de la Terre et du Soleil. On voit la portion de la Lune éclairée par le Soleil selon l'angle d'observation."),
                    Paragraph(title: "🌊 Influence sur la Terre", text: "La Lune influence les marées terrestres et pourrait affecter certains rythmes biologiques. Les effets sur l’humeur ou le sommeil sont encore débattus scientifiquement."),
                    Paragraph(title: "💡 Astuce mnémotechnique", text: "Dans l’hémisphère nord : si la lumière est à droite (comme un 'D'), la Lune est en croissance. Si la lumière est à gauche (comme un 'G'), elle est en décroissance.")
                ],
                lightColor: Color(red: 0.851, green: 0.8509803921568627, blue: 0.8509803921568627, opacity: 0.5),
                darkColor: Color(red: 0.792156862745098, green: 0.792156862745098, blue: 0.792156862745098, opacity: 1)
            ),
            
            Cycle(
                name: "Saisonnier",
                duration: 365,
                texts: [
                    Paragraph(title: "🌱 Printemps (Équinoxe de Mars)", text: "Débute autour du 20-21 mars dans l'hémisphère nord. Le jour et la nuit sont de durée égale. C’est une période de renaissance, de floraison, et de retour de la lumière."),
                    Paragraph(title: "🌞 Été (Solstice de Juin)", text: "Commence autour du 20-21 juin. C’est le jour le plus long de l’année. Le Soleil atteint son point culminant dans le ciel. Cette saison symbolise l’abondance, la chaleur et l’énergie."),
                    Paragraph(title: "🍂 Automne (Équinoxe de Septembre)", text: "Vers le 22-23 septembre, jour et nuit sont à nouveau équilibrés. L’automne est la saison des récoltes, du lâcher-prise et de l’introspection."),
                    Paragraph(title: "❄️ Hiver (Solstice de Décembre)", text: "Commence autour du 21-22 décembre. C’est la nuit la plus longue de l’année. L’hiver est une phase de repos, de régénération et de retour à l’essentiel."),
                    Paragraph(title: "🌀 Cause des saisons", text: "Les saisons sont causées par l’inclinaison de l’axe de la Terre (23,5°) combinée à sa révolution autour du Soleil. L’ensoleillement varie selon la latitude et la période de l’année."),
                    Paragraph(title: "📏 Solstices", text: "Deux moments clés de l’année où le Soleil atteint son point le plus haut (été) ou le plus bas (hiver) dans le ciel à midi. Cela provoque la journée ou la nuit la plus longue."),
                    Paragraph(title: "⚖️ Équinoxes", text: "Deux fois par an (printemps et automne), le Soleil est exactement au-dessus de l’équateur. Le jour et la nuit durent alors presque exactement 12 heures partout sur Terre."),
                    Paragraph(title: "🔄 Cycle annuel", text: "Le cycle saisonnier complet dure un an, synchronisé avec la révolution de la Terre autour du Soleil. Chaque saison dure environ 3 mois."),
                    Paragraph(title: "🌍 Hémisphères opposés", text: "Quand c’est l’été dans l’hémisphère nord, c’est l’hiver dans l’hémisphère sud, et vice versa. Les saisons sont donc inversées selon la position sur le globe."),
                    Paragraph(title: "🌼 Symbolique des saisons", text: "Chaque saison porte une énergie symbolique : le printemps = naissance, l’été = pleine expression, l’automne = transformation, l’hiver = repos intérieur.")
                ],
                lightColor: Color(red: 0.92, green: 0.8, blue: 0.55, opacity: 0.5),
                darkColor: Color(red: 0.92, green: 0.8, blue: 0.55, opacity: 1)
            ),
            Cycle(
                name: "Genre Féminin",
                duration: 28,
                texts: [
                    Paragraph(title: "🩸 Phase menstruelle (Jours 1–5)", text: "Le corps élimine la muqueuse utérine. Le taux d’œstrogènes et de progestérone est bas. C’est un moment de fatigue, de repos et d’introspection."),
                    Paragraph(title: "🌱 Phase folliculaire (Jours 6–13)", text: "Les ovaires commencent à développer des follicules. Le taux d’œstrogènes augmente, l’énergie revient. C’est un moment propice à la créativité, à l’élan et à la planification."),
                    Paragraph(title: "💫 Ovulation (Jours 14–16)", text: "L’ovaire libère un ovule. Pic d’œstrogènes et de testostérone. Énergie, charisme et sociabilité sont au maximum."),
                    Paragraph(title: "🌘 Phase lutéale (Jours 17–28)", text: "Le corps produit de la progestérone. Les émotions sont plus intenses, la fatigue peut s’installer. C’est le moment du bilan, du recentrage, de l’écoute intérieure."),
                    Paragraph(title: "🔄 Rappel physiologique", text: "Le cycle menstruel moyen dure 28 jours. Il est divisé en 4 phases qui influencent l’humeur, la motivation et l’énergie hormonale."),
                    Paragraph(title: "🌸 Symbolique énergétique", text: "Menstruelle = hiver, Folliculaire = printemps, Ovulation = été, Lutéale = automne. Le cycle est un miroir des saisons internes.")
                ],
                lightColor: Color(red: 0.71, green: 0.56, blue: 0.68, opacity: 0.5),
                darkColor: Color(red: 0.71, green: 0.56, blue: 0.68, opacity: 1)
            ),
            Cycle(
                name: "Genre Masculin",
                duration: 24,
                texts: [
                    Paragraph(title: "Introduction", text: "Le cycle hormonal masculin suit une variation quotidienne, avec des fluctuations de testostérone et d’énergie tout au long de la journée."),
                    Paragraph(title: "Matin (6h–10h)", text: "La testostérone est au plus haut. C’est le meilleur moment pour prendre des décisions, initier des projets ou faire de l’exercice."),
                    Paragraph(title: "Midi (10h–15h)", text: "L’énergie reste élevée. Le corps est performant, et la capacité d'exécution est optimale."),
                    Paragraph(title: "Soir (15h–21h)", text: "L’énergie commence à diminuer. C’est un bon moment pour des échanges sociaux ou une activité douce."),
                    Paragraph(title: "Nuit (21h–6h)", text: "Le corps se régénère. Le repos est essentiel pour stabiliser les niveaux hormonaux et restaurer l’énergie mentale et physique.")
                ],
                lightColor: Color(red: 0.53, green: 0.75, blue: 0.82, opacity: 0.5),
                darkColor: Color(red: 0.53, green: 0.75, blue: 0.82, opacity: 1)
            )
        ]
    }
}
