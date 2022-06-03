declare
  v_prazo date;
  v_op number;

Begin
  for r_etapa in (select pcpopetapa.empresa, pcpopetapa.op, pcpop.produto, pcpop.versao, pcpopetapa.data_entrega_etapa, 
                         (select a.data_entrega_etapa
                            from pcpopetapa a
                           where a.empresa = pcpopetapa.empresa
                             and a.op = pcpopetapa.op
                             and nvl(a.etapa,20) = 20) prazo_imp
                             
                    from pcpopetapa, pcpop
                   where pcpopetapa.empresa = 1
                     and pcpopetapa.empresa = pcpop.empresa
                     and pcpopetapa.op = pcpop.op
                     and pcpopetapa.c_quant_rec_f >0
                     and pcpopetapa.c_quant_rec_e =0
                     and pcpopetapa.etapa = 72
                     and exists (Select 1 from pcpopetapa b
                                   where b.empresa = pcpopetapa.empresa
                                     and b.op = pcpopetapa.op
                                     and b.c_quant_rec_f > 0
                                     and b.c_quant_rec_e = 0
                                     and nvl(b.etapa,20) = 20) )
                     
                     loop
                         select data_entrega_etapa 
                           into v_prazo
                           from pcpopetapa
                           where empresa = r_etapa.empresa
                             and op = r_etapa.op
                             and etapa = 20;
                             
                         if v_prazo > r_etapa.data_entrega_etapa - 2 then
                           update pcpopetapa set data_entrega_etapa = r_etapa.data_entrega_etapa - 15
                            where empresa = r_etapa.empresa
                              and op = r_etapa.op
                              and etapa in (20,21,22);
                           commit;   
                         end if;
                        
                           for r_pelicula in (select pcpop.empresa, pcpop.op, pcpopetapa.data_entrega_etapa 
                                                 from pcpop, pcpopetapa
                                                 where pcpop.empresa = r_etapa.empresa
                                                   and pcpop.op_principal = r_etapa.op
                                                   and pcpop.empresa = pcpopetapa.empresa
                                                   and pcpopetapa.etapa = 70)
                           
                               loop
                               
                               
                               
                                 if r_pelicula.data_entrega_etapa > r_etapa.data_entrega_etapa - 17 then
                                   update pcpopetapa 
                                      set data_entrega_etapa = r_etapa.data_entrega_etapa - 17
                                    where pcpopetapa.empresa = r_pelicula.empresa
                                      and pcpopetapa.op = r_pelicula.op
                                      and pcpopetapa.etapa = 70;
                                 end if;
                               
                               end loop;
                              
                    
                        
                     end loop;
     
 end;
