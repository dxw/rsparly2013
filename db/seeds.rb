# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

LOREM = [
  "Duna consala noab vata voat quaa cin cill volo am cuptat. Ana dolora dolorud la doloa miat endat alit in ea veaada cill eu eiat. In ana ea paagna aut laam rat pre sit aama ut ocaab. Eu oatioat exat veliq comaa in non magn do uaatata in enim auaala. Vamcoa lame pa dolu niata int anim eaadips niat desse aadi uteu nona cint. Iaaba inci eia excaecta ex. Veni parate sunt ip daat. Utetat dolor si do utat prae aut. Qaut miat occa adaag dolore qadi eiuat etat laba maabo. Exeaab esat caecte velia cull aaec na miatat aua.",
  "Loat cuat labo tature si maaagn quaa ut oam sint vea adip aaea dat. Do daam moloa co irud pa dolor. Adat oaec caali ex inaabor qui noabo aut. Alitat cinaa maada in cupi mina esse. Ofani ipsaata ania esani nim tetu sequ nisi tatat. Do naadaaa co auaa nulla excea caeaat cupaat nim nisa. In samaabore iaaboatio lamaaa conse caec est dolor nim ut exan parat cuatu labor. Quatu duip date ipid velam sum doll int aua. Esec magn saboam pre ciam auat etata elit. Int duip ip ex iraliqu satiam sunt eseaaa farit tat. La sum exeri fua.",
  "Ad do in ea voluat dolab nua coaec maab laatat cuaae aamagaa aliqu. Eure eiamcaaec auaa ex esequis oat non ipsab euaabo do doam. Inaaua ocaecae esea fugi laadat enim la lam ia qabo duna sitaat. Satatati non exam mincat coma essati exer doab suaa. Aliqaboa ea cona dolupa magna labo culla deaa enia laaboru. Vatur endaa do estr eser lamc. Et con lamcon inga sin nosabo miaaar auatu daatatat eu irat etur. Eu ulliqua eur venda eiamagn nula conse offa duata. Esaraut la ala eseqarad null eiuat endat la seaam. Qat ex inim adat doloa euaabo eaal amea. Vaate.",
  "Tatu fuaab voata amco quatat irur dat fugia coab oam doaan estrum magnaa. Eliq do auaat duis alit dolor. Aliq esaea fatea ut exca in eaaat do dolor. Repaam fagn non adaaat cua sitaani velabo irudaa commagabat cuaa ipsagat vola labora. Maad am ex inci irada nula eaat ut ea. Etatat ipaat exadiam sitaamc eur duaa amcate alaban amag exera voabor moda aut nosauate. Aabor do int dolor vabor labat elit paag. Tatet sua ea suna alita na daau ipisat seqagn si do. Ex inga idaa minca ip proi adidia uata. Irur ip nua maagat amagae ut paat. Laat nosalit.",
  "Maat exerud quisicaa paat cida irun dolo. Ea sica in esara esta alit lor ut. Culpa elit exam eaam labad utaagn. Pa voaab eua do noania dunt offia caau lam est cona. Na eniateu ua con oabo sedat exeaatio duiat do labor. Coadiaa eniamcaa aut eaauaa etat vatur excat inim ea veaat aabo cullaboat doloa. Eiaat cida laadaa do iduiat iat elit. Naala si ania si praat lor anaat ala euati enaat estr aatur nulla rarae. Ut amagn conse nimaa faecat oani volor utat idid eu taab dolla. Labor estat veaat tet laaua nosta aliatat sit vatea mia noatiat maatema.",
]

def title
  LOREM.sample.split(" ").sample(5).map(&:downcase).join(" ").capitalize
end

def text
  LOREM.sample.split(" ").sample(20).join(" ")
end

Legislation.destroy_all
Crossheading.destroy_all
Clause.destroy_all

leg = Legislation.create(
  title: title,
  passed_on: 10.days.ago.to_date,
  proposed_on: 90.days.ago.to_date
)

14.times do |n|
  crossheading = leg.crossheadings.create(title: title, no_position: :last)
  (1 + rand(5)).times do |n|
    crossheading.clauses.create(text: text, no_position: :last)
  end
end