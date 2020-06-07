fifo_bufer	fifo_bufer_inst (
	.clock ( clock_sig ),
	.data ( data_sig ),
	.rdreq ( rdreq_sig ),
	.wrreq ( wrreq_sig ),
	.almost_full ( almost_full_sig ),
	.empty ( empty_sig ),
	.q ( q_sig ),
	.usedw ( usedw_sig )
	);
