CREATE OR REPLACE function randomWord(numOfCharacters integer) RETURNS text AS $$
 DECLARE
  word text := '';
  alphabet varchar := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
 BEGIN
 for cnt in 1..numOfCharacters loop
 	
    word = word || (substr(alphabet,(random() * length(alphabet) + 1):: integer,1));
 end loop;
 return word;
 END;
 $$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION idoc2(id bigint) RETURNS text AS $$
        BEGIN
        return (SELECT '
  <INVOIC' || id || ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="INVOIC02.xsd">
	<IDOC BEGIN="1">
		<!-- Kontrollsatz -->
		<EDI_DC40 SEGMENT="1">
			<TABNAM>EDI_'|| md5(id::text)||'</TABNAM>
			<tag1>'||randomSentence(2)||'</tag1>
		</EDI_DC40>
		<!-- Kopfdatensätze -->
		<E1EDK01 SEGMENT="1">
			<CURCY>'|| randomWord(3) || '</CURCY>
			<someNumber>'|| (random() * 99999 + 1000) ||'</someNumber>
		</E1EDK01>
		<!-- Positionsdatensätze -->
		<E1EDP01 SEGMENT="1">
			<POSEX>'|| randomSentence(5) ||'</POSEX>
			<foo>'|| randomSentence(15) ||'</foo>
		</E1EDP01>
		<!-- Summendatensätze -->
		<E1EDS01 SEGMENT="1">
			<SUMID>'|| randomWord(30) || '</SUMID>
			<SUMME>'|| (random() * 99999 + 1000) || '</SUMME>
		</E1EDS01>
		<booleanV>'|| (random())::integer::boolean || '</booleanV>
	</IDOC>
</INVOIC' || id ||'>');
        END;
	$$ LANGUAGE plpgsql;



CREATE OR REPLACE function randomSentence(numOfWords integer) RETURNS text AS $$
 DECLARE
  sentence text := '';
 BEGIN
 for cnt in 1..numOfWords loop
    sentence = sentence || ' ' || randomWord(((random() * 6) + 2):: integer);
 end loop;
 return sentence;
 END;
 $$ LANGUAGE plpgsql;
 
 
 SELECT randomWord(20);
 SELECT randomSentence(28);


  INSERT INTO t_payload(p_content)
 SELECT
  idoc2(id) as p_content
FROM
  generate_series(1, 10000000) AS id;





  