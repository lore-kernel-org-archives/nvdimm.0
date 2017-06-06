Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A216121959CAC
 for <linux-nvdimm@lists.01.org>; Mon,  5 Jun 2017 22:50:22 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 0D9C7AC0116
 for <linux-nvdimm@lists.01.org>; Tue,  6 Jun 2017 14:51:22 +0900 (JST)
Date: Tue, 06 Jun 2017 14:51:13 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: Panic when make check for ndctl
In-Reply-To: <c769be43-0c73-8934-06a0-0c5b6f6a975d@gmail.com>
References: <CAPcyv4hGL8ZXfsnN4jossEr2VEFSA7iBaAnx94czryBy7cDahQ@mail.gmail.com>
 <c769be43-0c73-8934-06a0-0c5b6f6a975d@gmail.com>
Message-Id: <20170606145109.7B82.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Yasunori Goto <ygotopersonal@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

> > No, you're not doing anything wrong. This is a known issue that I am
> > investigating. The reports of this usually come from distributions
> > with older module loading infrastructure. If you can try with a recent
> > Fedora that would mimic the environment I normally use to test,
> 
> Oh, I see. Certainly, I used CentOS7.
> Ok, I'll use Fedora environment.

Hmmm, though I made Fedora 25 environment, this panic still occurs...
I'll attach syslog and .config again.


[  105.119978] nfit_test_iomap: loading out-of-tree module taints kernel.
[  105.306302] nfit_test nfit_test.0: found a zero length table '0' parsing nfit
[  106.573244] random: crng init done
[  107.339579] nfit_test nfit_test.0: failed to evaluate _FIT
[  107.358018] nfit_test nfit_test.1: nmem4 flags: save_fail restore_fail flush_fail not_armed
[  107.360586] nfit_test nfit_test.1: nmem5 flags: map_fail
[  107.480603] pmem4: detected capacity change from 0 to 18874368
[  107.510795] pmem4: detected capacity change from 0 to 18874368
[  107.539968] pmem4: detected capacity change from 0 to 18874368
[  107.630683] pmem5: detected capacity change from 0 to 20971520
[  107.662595] pmem5: detected capacity change from 0 to 20971520
[  107.697813] pmem5: detected capacity change from 0 to 20971520
[  107.738166] ndblk0.0: detected capacity change from 0 to 7340032
[  107.768583] ndblk0.0: detected capacity change from 0 to 7340032
[  107.797455] ndblk0.0: detected capacity change from 0 to 6524416
[  107.823556] ndblk0.0: detected capacity change from 0 to 6524416
[  107.853451] ndblk0.0: detected capacity change from 0 to 6524416
[  107.883705] ndblk0.0: detected capacity change from 0 to 6524416
[  107.913563] ndblk0.0: detected capacity change from 0 to 7340032
[  107.948093] ndblk0.0: detected capacity change from 0 to 7340032
[  107.982461] ndblk0.0: detected capacity change from 0 to 7225344
[  108.015363] ndblk0.0: detected capacity change from 0 to 7225344
[  108.046480] ndblk0.0: detected capacity change from 0 to 7225344
[  108.071713] ndblk0.0: detected capacity change from 0 to 7225344
[  108.098458] ndblk0.0: detected capacity change from 0 to 7114752
[  108.127799] ndblk0.0: detected capacity change from 0 to 7114752
[  108.133122] ndblk0.1: detected capacity change from 0 to 11534336
[  108.162370] ndblk0.1: detected capacity change from 0 to 11534336
[  108.192647] ndblk0.1: detected capacity change from 0 to 10252288
[  108.218613] ndblk0.1: detected capacity change from 0 to 10252288
[  108.248650] ndblk0.1: detected capacity change from 0 to 10252288
[  108.276487] ndblk0.1: detected capacity change from 0 to 10252288
[  108.307132] ndblk0.1: detected capacity change from 0 to 11534336
[  108.336644] ndblk0.1: detected capacity change from 0 to 11534336
[  108.366668] ndblk0.1: detected capacity change from 0 to 11354112
[  108.399347] ndblk0.1: detected capacity change from 0 to 11354112
[  108.428403] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[  108.428679] pmem7: detected capacity change from 0 to 4194304
[  108.439346] pmem6: detected capacity change from 0 to 33554432
[  108.448567] ndblk0.1: detected capacity change from 0 to 11354112
[  108.475539] ndblk0.1: detected capacity change from 0 to 11354112
[  108.501562] ndblk0.1: detected capacity change from 0 to 11182080
[  108.529544] ndblk0.1: detected capacity change from 0 to 11182080
[  108.580854] ndblk0.1: detected capacity change from 0 to 7340032
[  108.580861] ndblk0.0: detected capacity change from 0 to 11534336
[  108.619809] ndblk0.1: detected capacity change from 0 to 7340032
[  108.644717] ndblk0.0: detected capacity change from 0 to 11534336
[  108.706521] ndblk1.0: detected capacity change from 0 to 7340032
[  108.735577] ndblk1.0: detected capacity change from 0 to 7340032
[  108.763659] ndblk1.0: detected capacity change from 0 to 6524416
[  108.793613] ndblk1.0: detected capacity change from 0 to 6524416
[  108.822612] ndblk1.0: detected capacity change from 0 to 6524416
[  108.852674] ndblk1.0: detected capacity change from 0 to 6524416
[  108.881684] ndblk1.0: detected capacity change from 0 to 7340032
[  108.911788] ndblk1.0: detected capacity change from 0 to 7340032
[  108.941352] ndblk1.0: detected capacity change from 0 to 7225344
[  108.970375] ndblk1.0: detected capacity change from 0 to 7225344
[  108.998504] ndblk1.0: detected capacity change from 0 to 7225344
[  109.031416] ndblk1.0: detected capacity change from 0 to 7225344
[  109.062783] ndblk1.0: detected capacity change from 0 to 7114752
[  109.088454] ndblk1.0: detected capacity change from 0 to 7114752
[  109.093521] ndblk1.1: detected capacity change from 0 to 11534336
[  109.127332] ndblk1.1: detected capacity change from 0 to 11534336
[  109.157533] ndblk1.1: detected capacity change from 0 to 10252288
[  109.183291] ndblk1.1: detected capacity change from 0 to 10252288
[  109.212336] ndblk1.1: detected capacity change from 0 to 10252288
[  109.238434] ndblk1.1: detected capacity change from 0 to 10252288
[  109.271471] ndblk1.1: detected capacity change from 0 to 11534336
[  109.297386] ndblk1.1: detected capacity change from 0 to 11534336
[  109.328372] ndblk1.1: detected capacity change from 0 to 11354112
[  109.361400] ndblk1.1: detected capacity change from 0 to 11354112
[  109.392430] ndblk1.1: detected capacity change from 0 to 11354112
[  109.428406] ndblk1.1: detected capacity change from 0 to 11354112
[  109.454491] ndblk1.1: detected capacity change from 0 to 11182080
[  109.487353] ndblk1.1: detected capacity change from 0 to 11182080
[  109.537879] ndblk1.1: detected capacity change from 0 to 7340032
[  109.537967] ndblk1.0: detected capacity change from 0 to 11534336
[  109.565350] ndblk1.1: detected capacity change from 0 to 7340032
[  109.598463] ndblk1.0: detected capacity change from 0 to 11534336
[  109.660689] ndblk2.0: detected capacity change from 0 to 28311552
[  109.690525] ndblk2.0: detected capacity change from 0 to 28311552
[  109.716581] ndblk2.0: detected capacity change from 0 to 25165824
[  109.745327] ndblk2.0: detected capacity change from 0 to 25165824
[  109.770396] ndblk2.0: detected capacity change from 0 to 25165824
[  109.803360] ndblk2.0: detected capacity change from 0 to 25165824
[  109.832330] ndblk2.0: detected capacity change from 0 to 28311552
[  109.858490] ndblk2.0: detected capacity change from 0 to 28311552
[  109.888490] ndblk2.0: detected capacity change from 0 to 27873280
[  109.917227] ndblk2.0: detected capacity change from 0 to 27873280
[  109.945591] ndblk2.0: detected capacity change from 0 to 27873280
[  109.974347] ndblk2.0: detected capacity change from 0 to 27873280
[  110.003344] ndblk2.0: detected capacity change from 0 to 27451392
[  110.032411] ndblk2.0: detected capacity change from 0 to 27451392
[  110.061529] ndblk2.0: detected capacity change from 0 to 28311552
[  110.095333] ndblk2.0: detected capacity change from 0 to 28311552
[  110.129210] ndblk3.0: detected capacity change from 0 to 28311552
[  110.156337] ndblk3.0: detected capacity change from 0 to 28311552
[  110.186749] ndblk3.0: detected capacity change from 0 to 25165824
[  110.216575] ndblk3.0: detected capacity change from 0 to 25165824
[  110.246734] ndblk3.0: detected capacity change from 0 to 25165824
[  110.274606] ndblk3.0: detected capacity change from 0 to 25165824
[  110.303706] ndblk3.0: detected capacity change from 0 to 28311552
[  110.332341] ndblk3.0: detected capacity change from 0 to 28311552
[  110.362347] ndblk3.0: detected capacity change from 0 to 27873280
[  110.391318] ndblk3.0: detected capacity change from 0 to 27873280
[  110.419590] ndblk3.0: detected capacity change from 0 to 27873280
[  110.449602] ndblk3.0: detected capacity change from 0 to 27873280
[  110.475609] ndblk3.0: detected capacity change from 0 to 27451392
[  110.509744] ndblk3.0: detected capacity change from 0 to 27451392
[  110.539967] ndblk3.0: detected capacity change from 0 to 28311552
[  110.568702] ndblk3.0: detected capacity change from 0 to 28311552
[  110.637689] pmem4: detected capacity change from 0 to 18866176
[  110.669552] pmem4: detected capacity change from 0 to 14700544
[  110.700010] pmem4: detected capacity change from 0 to 14700544
[  110.736370] pmem4: detected capacity change from 0 to 14700544
[  110.767042] pmem4: detected capacity change from 0 to 18874368
[  110.798402] pmem4: detected capacity change from 0 to 18874368
[  110.828564] pmem4: detected capacity change from 0 to 18874368
[  110.864839] pmem5: detected capacity change from 0 to 20963328
[  110.899520] pmem5: detected capacity change from 0 to 16801792
[  110.931500] pmem5: detected capacity change from 0 to 16801792
[  110.965372] pmem5: detected capacity change from 0 to 16801792
[  110.996902] pmem5: detected capacity change from 0 to 20971520
[  111.028319] pmem5: detected capacity change from 0 to 20971520
[  111.061723] pmem5: detected capacity change from 0 to 20971520
[  111.096534] ndblk0.0: detected capacity change from 0 to 7340032
[  111.126313] ndblk0.0: detected capacity change from 0 to 7340032
[  111.155570] ndblk0.0: detected capacity change from 0 to 6524416
[  111.188508] ndblk0.0: detected capacity change from 0 to 6524416
[  111.218726] ndblk0.0: detected capacity change from 0 to 6524416
[  111.248807] ndblk0.0: detected capacity change from 0 to 6524416
[  111.279621] ndblk0.0: detected capacity change from 0 to 7340032
[  111.309380] ndblk0.0: detected capacity change from 0 to 7340032
[  111.343599] ndblk0.0: detected capacity change from 0 to 7225344
[  111.371350] ndblk0.0: detected capacity change from 0 to 7225344
[  111.396568] ndblk0.0: detected capacity change from 0 to 7225344
[  111.422790] ndblk0.0: detected capacity change from 0 to 7225344
[  111.449014] ndblk0.0: detected capacity change from 0 to 7114752
[  111.479696] ndblk0.0: detected capacity change from 0 to 7114752
[  111.484436] ndblk0.1: detected capacity change from 0 to 11534336
[  111.511601] ndblk0.1: detected capacity change from 0 to 11534336
[  111.537681] ndblk0.1: detected capacity change from 0 to 10252288
[  111.562396] ndblk0.1: detected capacity change from 0 to 10252288
[  111.589685] ndblk0.1: detected capacity change from 0 to 10252288
[  111.619815] ndblk0.1: detected capacity change from 0 to 10252288
[  111.646740] ndblk0.1: detected capacity change from 0 to 11534336
[  111.676715] ndblk0.1: detected capacity change from 0 to 11534336
[  111.702806] ndblk0.1: detected capacity change from 0 to 11354112
[  111.729349] ndblk0.1: detected capacity change from 0 to 11354112
[  111.756575] ndblk0.1: detected capacity change from 0 to 11354112
[  111.787806] ndblk0.1: detected capacity change from 0 to 11354112
[  111.817861] ndblk0.1: detected capacity change from 0 to 11182080
[  111.846802] ndblk0.1: detected capacity change from 0 to 11182080
[  111.898048] ndblk0.1: detected capacity change from 0 to 7340032
[  111.898069] ndblk0.0: detected capacity change from 0 to 11534336
[  111.926589] ndblk0.1: detected capacity change from 0 to 7340032
[  111.954610] ndblk0.0: detected capacity change from 0 to 11534336
[  112.013684] ndblk1.0: detected capacity change from 0 to 7340032
[  112.041567] ndblk1.0: detected capacity change from 0 to 7340032
[  112.067506] ndblk1.0: detected capacity change from 0 to 6524416
[  112.099657] ndblk1.0: detected capacity change from 0 to 6524416
[  112.128561] ndblk1.0: detected capacity change from 0 to 6524416
[  112.160662] ndblk1.0: detected capacity change from 0 to 6524416
[  112.190756] ndblk1.0: detected capacity change from 0 to 7340032
[  112.220656] ndblk1.0: detected capacity change from 0 to 7340032
[  112.253664] ndblk1.0: detected capacity change from 0 to 7225344
[  112.283519] ndblk1.0: detected capacity change from 0 to 7225344
[  112.309701] ndblk1.0: detected capacity change from 0 to 7225344
[  112.342567] ndblk1.0: detected capacity change from 0 to 7225344
[  112.372528] ndblk1.0: detected capacity change from 0 to 7114752
[  112.405435] ndblk1.0: detected capacity change from 0 to 7114752
[  112.409926] ndblk1.1: detected capacity change from 0 to 11534336
[  112.438331] ndblk1.1: detected capacity change from 0 to 11534336
[  112.466617] ndblk1.1: detected capacity change from 0 to 10252288
[  112.497657] ndblk1.1: detected capacity change from 0 to 10252288
[  112.528683] ndblk1.1: detected capacity change from 0 to 10252288
[  112.562610] ndblk1.1: detected capacity change from 0 to 10252288
[  112.595812] ndblk1.1: detected capacity change from 0 to 11534336
[  112.625853] ndblk1.1: detected capacity change from 0 to 11534336
[  112.655840] ndblk1.1: detected capacity change from 0 to 11354112
[  112.685837] ndblk1.1: detected capacity change from 0 to 11354112
[  112.715739] ndblk1.1: detected capacity change from 0 to 11354112
[  112.743641] ndblk1.1: detected capacity change from 0 to 11354112
[  112.775647] ndblk1.1: detected capacity change from 0 to 11182080
[  112.803627] ndblk1.1: detected capacity change from 0 to 11182080
[  112.856962] ndblk1.0: detected capacity change from 0 to 11534336
[  112.871023] ndblk1.1: detected capacity change from 0 to 7340032
[  112.898543] ndblk1.1: detected capacity change from 0 to 7340032
[  112.928733] ndblk1.0: detected capacity change from 0 to 11534336
[  112.988305] ndblk2.0: detected capacity change from 0 to 28311552
[  113.015628] ndblk2.0: detected capacity change from 0 to 28311552
[  113.047834] ndblk2.0: detected capacity change from 0 to 25165824
[  113.077795] ndblk2.0: detected capacity change from 0 to 25165824
[  113.119912] ndblk2.0: detected capacity change from 0 to 25165824
[  113.148630] ndblk2.0: detected capacity change from 0 to 25165824
[  113.177691] ndblk2.0: detected capacity change from 0 to 28311552
[  113.206434] ndblk2.0: detected capacity change from 0 to 28311552
[  113.235665] ndblk2.0: detected capacity change from 0 to 27873280
[  113.265569] ndblk2.0: detected capacity change from 0 to 27873280
[  113.293662] ndblk2.0: detected capacity change from 0 to 27873280
[  113.322613] ndblk2.0: detected capacity change from 0 to 27873280
[  113.351621] ndblk2.0: detected capacity change from 0 to 27451392
[  113.380707] ndblk2.0: detected capacity change from 0 to 27451392
[  113.414204] ndblk2.0: detected capacity change from 0 to 28311552
[  113.445534] ndblk2.0: detected capacity change from 0 to 28311552
[  113.479150] ndblk3.0: detected capacity change from 0 to 28311552
[  113.508569] ndblk3.0: detected capacity change from 0 to 28311552
[  113.539519] ndblk3.0: detected capacity change from 0 to 25165824
[  113.571755] ndblk3.0: detected capacity change from 0 to 25165824
[  113.601544] ndblk3.0: detected capacity change from 0 to 25165824
[  113.631450] ndblk3.0: detected capacity change from 0 to 25165824
[  113.661343] ndblk3.0: detected capacity change from 0 to 28311552
[  113.690698] ndblk3.0: detected capacity change from 0 to 28311552
[  113.720616] ndblk3.0: detected capacity change from 0 to 27873280
[  113.746796] ndblk3.0: detected capacity change from 0 to 27873280
[  113.775765] ndblk3.0: detected capacity change from 0 to 27873280
[  113.804548] ndblk3.0: detected capacity change from 0 to 27873280
[  113.834762] ndblk3.0: detected capacity change from 0 to 27451392
[  113.865715] ndblk3.0: detected capacity change from 0 to 27451392
[  113.900500] ndblk3.0: detected capacity change from 0 to 28311552
[  113.929600] ndblk3.0: detected capacity change from 0 to 28311552
[  113.980479] nd_pmem btt4.0: No existing arenas
[  113.983934] pmem4s: detected capacity change from 0 to 18564096
[  114.020170] pmem4s: detected capacity change from 0 to 18564096
[  114.053960] pmem4s: detected capacity change from 0 to 18564096
[  114.088905] pmem4s: detected capacity change from 0 to 148512768
[  114.123022] pmem4s: detected capacity change from 0 to 148512768
[  114.156559] pmem4s: detected capacity change from 0 to 148512768
[  114.192973] pmem4s: detected capacity change from 0 to 148512768
[  114.227204] pmem4s: detected capacity change from 0 to 18564096
[  114.262795] pmem4s: detected capacity change from 0 to 18564096
[  114.296797] pmem4: detected capacity change from 0 to 18874368
[  114.332711] pmem4: detected capacity change from 0 to 18874368
[  114.362463] pmem4: detected capacity change from 0 to 18874368
[  114.400217] nd_pmem btt5.0: No existing arenas
[  114.404187] pmem5s: detected capacity change from 0 to 20644864
[  114.442874] pmem5s: detected capacity change from 0 to 20644864
[  114.480026] pmem5s: detected capacity change from 0 to 20644864
[  114.515993] pmem5s: detected capacity change from 0 to 165158912
[  114.552262] pmem5s: detected capacity change from 0 to 165158912
[  114.592288] pmem5s: detected capacity change from 0 to 165158912
[  114.628456] pmem5s: detected capacity change from 0 to 165158912
[  114.667815] pmem5s: detected capacity change from 0 to 20644864
[  114.698337] pmem5s: detected capacity change from 0 to 20644864
[  114.727759] pmem5: detected capacity change from 0 to 20971520
[  114.759815] pmem5: detected capacity change from 0 to 20971520
[  114.792048] pmem5: detected capacity change from 0 to 20971520
[  114.827093] ndblk0.0: detected capacity change from 0 to 7340032
[  114.855851] ndblk0.0: detected capacity change from 0 to 7340032
[  114.882503] ndblk0.0: detected capacity change from 0 to 6524416
[  114.912396] ndblk0.0: detected capacity change from 0 to 6524416
[  114.942545] ndblk0.0: detected capacity change from 0 to 6524416
[  114.972699] ndblk0.0: detected capacity change from 0 to 6524416
[  115.003739] ndblk0.0: detected capacity change from 0 to 7340032
[  115.032844] ndblk0.0: detected capacity change from 0 to 7340032
[  115.058561] ndblk0.0: detected capacity change from 0 to 7225344
[  115.084344] ndblk0.0: detected capacity change from 0 to 7225344
[  115.113604] ndblk0.0: detected capacity change from 0 to 7225344
[  115.144313] ndblk0.0: detected capacity change from 0 to 7225344
[  115.173577] ndblk0.0: detected capacity change from 0 to 7114752
[  115.201318] ndblk0.0: detected capacity change from 0 to 7114752
[  115.206551] ndblk0.1: detected capacity change from 0 to 11534336
[  115.233525] ndblk0.1: detected capacity change from 0 to 11534336
[  115.261761] ndblk0.1: detected capacity change from 0 to 10252288
[  115.290866] ndblk0.1: detected capacity change from 0 to 10252288
[  115.319724] ndblk0.1: detected capacity change from 0 to 10252288
[  115.348726] ndblk0.1: detected capacity change from 0 to 10252288
[  115.375692] ndblk0.1: detected capacity change from 0 to 11534336
[  115.402375] ndblk0.1: detected capacity change from 0 to 11534336
[  115.428721] ndblk0.1: detected capacity change from 0 to 11354112
[  115.457458] ndblk0.1: detected capacity change from 0 to 11354112
[  115.487723] ndblk0.1: detected capacity change from 0 to 11354112
[  115.517554] ndblk0.1: detected capacity change from 0 to 11354112
[  115.547857] ndblk0.1: detected capacity change from 0 to 11182080
[  115.576733] ndblk0.1: detected capacity change from 0 to 11182080
[  115.627671] ndblk0.0: detected capacity change from 0 to 11534336
[  115.627688] ndblk0.1: detected capacity change from 0 to 7340032
[  115.659725] ndblk0.1: detected capacity change from 0 to 7340032
[  115.689442] ndblk0.0: detected capacity change from 0 to 11534336
[  115.745343] ndblk1.0: detected capacity change from 0 to 7340032
[  115.775727] ndblk1.0: detected capacity change from 0 to 7340032
[  115.805728] ndblk1.0: detected capacity change from 0 to 6524416
[  115.831536] ndblk1.0: detected capacity change from 0 to 6524416
[  115.861891] ndblk1.0: detected capacity change from 0 to 6524416
[  115.891832] ndblk1.0: detected capacity change from 0 to 6524416
[  115.921839] ndblk1.0: detected capacity change from 0 to 7340032
[  115.951448] ndblk1.0: detected capacity change from 0 to 7340032
[  115.977690] ndblk1.0: detected capacity change from 0 to 7225344
[  116.010474] ndblk1.0: detected capacity change from 0 to 7225344
[  116.039340] ndblk1.0: detected capacity change from 0 to 7225344
[  116.065740] ndblk1.0: detected capacity change from 0 to 7225344
[  116.095687] ndblk1.0: detected capacity change from 0 to 7114752
[  116.124474] ndblk1.0: detected capacity change from 0 to 7114752
[  116.130332] ndblk1.1: detected capacity change from 0 to 11534336
[  116.156512] ndblk1.1: detected capacity change from 0 to 11534336
[  116.186542] ndblk1.1: detected capacity change from 0 to 10252288
[  116.223188] ndblk1.1: detected capacity change from 0 to 10252288
[  116.250695] ndblk1.1: detected capacity change from 0 to 10252288
[  116.280524] ndblk1.1: detected capacity change from 0 to 10252288
[  116.306568] ndblk1.1: detected capacity change from 0 to 11534336
[  116.335389] ndblk1.1: detected capacity change from 0 to 11534336
[  116.365484] ndblk1.1: detected capacity change from 0 to 11354112
[  116.390303] ndblk1.1: detected capacity change from 0 to 11354112
[  116.418332] ndblk1.1: detected capacity change from 0 to 11354112
[  116.444226] ndblk1.1: detected capacity change from 0 to 11354112
[  116.469322] ndblk1.1: detected capacity change from 0 to 11182080
[  116.500557] ndblk1.1: detected capacity change from 0 to 11182080
[  116.554723] ndblk1.0: detected capacity change from 0 to 11534336
[  116.554895] ndblk1.1: detected capacity change from 0 to 7340032
[  116.583641] ndblk1.1: detected capacity change from 0 to 7340032
[  116.613324] ndblk1.0: detected capacity change from 0 to 11534336
[  116.671228] nd_blk btt2.0: No existing arenas
[  116.675514] ndblk2.0s: detected capacity change from 0 to 27928064
[  116.711302] ndblk2.0s: detected capacity change from 0 to 27928064
[  116.750457] ndblk2.0s: detected capacity change from 0 to 27928064
[  116.786165] ndblk2.0s: detected capacity change from 0 to 223424512
[  116.821733] ndblk2.0s: detected capacity change from 0 to 223424512
[  116.857652] ndblk2.0s: detected capacity change from 0 to 223424512
[  116.890435] ndblk2.0s: detected capacity change from 0 to 223424512
[  116.925862] ndblk2.0s: detected capacity change from 0 to 27928064
[  116.967171] ndblk2.0s: detected capacity change from 0 to 27928064
[  117.000647] ndblk2.0: detected capacity change from 0 to 28311552
[  117.026754] ndblk2.0: detected capacity change from 0 to 28311552
[  117.056780] ndblk2.0: detected capacity change from 0 to 28311552
[  117.091005] nd_blk btt3.0: No existing arenas
[  117.094760] ndblk3.0s: detected capacity change from 0 to 27928064
[  117.129367] ndblk3.0s: detected capacity change from 0 to 27928064
[  117.165070] ndblk3.0s: detected capacity change from 0 to 27928064
[  117.200090] ndblk3.0s: detected capacity change from 0 to 223424512
[  117.235165] ndblk3.0s: detected capacity change from 0 to 223424512
[  117.274015] ndblk3.0s: detected capacity change from 0 to 223424512
[  117.316141] ndblk3.0s: detected capacity change from 0 to 223424512
[  117.350107] ndblk3.0s: detected capacity change from 0 to 27928064
[  117.380054] ndblk3.0s: detected capacity change from 0 to 27928064
[  117.414741] ndblk3.0: detected capacity change from 0 to 28311552
[  117.442741] ndblk3.0: detected capacity change from 0 to 28311552
[  117.471744] ndblk3.0: detected capacity change from 0 to 28311552
[  117.529686] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[  117.535374] pmem6: detected capacity change from 0 to 33554432
[  117.541192] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[  117.543681] pmem6: detected capacity change from 33554432 to 0
[  117.569779] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[  117.573036] pmem6: detected capacity change from 0 to 33554432
[  117.604734] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[  117.607796] pmem6: detected capacity change from 0 to 33554432
[  117.613821] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[  117.616799] pmem6: detected capacity change from 33554432 to 0
[  117.641595] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[  117.644598] pmem6: detected capacity change from 0 to 33554432
[  117.719438] list_del corruption. next->prev should be ffff88041cac41e0, but was 65745f7469666e3a
[  117.722832] ------------[ cut here ]------------
[  117.724477] WARNING: CPU: 4 PID: 2233 at lib/list_debug.c:56 __list_del_entry_valid+0x6c/0xa0
[  117.727507] Modules linked in: dax_pmem(O) device_dax(O) nd_pmem(O) nd_blk(O) nd_btt(O) nfit_test(O-) nfit(O) libnvdimm(O) nfit_test_iomap(O) rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache sunrpc ppdev parport_pc pcspkr i2c_piix4 parport floppy i2c_core virtio_net virtio_balloon acpi_cpufreq sch_fq_codel ip_tables xfs libcrc32c sr_mod cdrom ata_generic pata_acpi virtio_console virtio_blk ata_piix libata virtio_pci crc32c_intel virtio_ring serio_raw virtio
[  117.741905] CPU: 4 PID: 2233 Comm: lt-libndctl Tainted: G           O    4.12.0-rc1+ #12
[  117.744461] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  117.746310] task: ffff88041d685500 task.stack: ffffc90002b50000
[  117.748198] RIP: 0010:__list_del_entry_valid+0x6c/0xa0
[  117.751084] RSP: 0018:ffffc90002b53d60 EFLAGS: 00010046
[  117.753142] RAX: 0000000000000054 RBX: ffffc9001700e000 RCX: 0000000000000000
[  117.755955] RDX: 0000000000000000 RSI: ffff88043310e0a8 RDI: ffff88043310e0a8
[  117.758745] RBP: ffffc90002b53d60 R08: 00000000fffffffe R09: 0000000000000382
[  117.760801] R10: 0000000000000005 R11: 0000000000000381 R12: ffffc90002b53d98
[  117.762949] R13: ffffc9001700e000 R14: 0000000000000000 R15: ffff88041beefc08
[  117.765000] FS:  00007f7d70082c80(0000) GS:ffff880433100000(0000) knlGS:0000000000000000
[  117.767300] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  117.768962] CR2: 000055c0db522cc0 CR3: 0000000422156000 CR4: 00000000000006e0
[  117.770975] Call Trace:
[  117.771716]  release_nodes+0x76/0x260
[  117.772797]  devres_release_all+0x3c/0x50
[  117.773981]  device_release_driver_internal+0x159/0x200
[  117.775494]  device_release_driver+0x12/0x20
[  117.776763]  bus_remove_device+0xfd/0x170
[  117.777924]  device_del+0x1e8/0x330
[  117.778943]  platform_device_del+0x28/0x90
[  117.780129]  platform_device_unregister+0x12/0x30
[  117.781483]  nfit_test_exit+0x2a/0x93b [nfit_test]
[  117.782858]  SyS_delete_module+0x171/0x250
[  117.784044]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[  117.785346] RIP: 0033:0x7f7d6f399487
[  117.786377] RSP: 002b:00007ffc604502a8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[  117.788503] RAX: ffffffffffffffda RBX: 0000000002000000 RCX: 00007f7d6f399487
[  117.790525] RDX: 00000000000000e8 RSI: 0000000000000800 RDI: 00000000020838f8
[  117.792635] RBP: 00007ffc6044fc60 R08: 000000000208fb00 R09: 0000000000000037
[  117.794641] R10: 000000000000006d R11: 0000000000000206 R12: 0000000000404e60
[  117.796656] R13: 00007ffc60450440 R14: 0000000000000000 R15: 0000000000000000
[  117.798699] Code: 48 89 c2 48 89 fe 31 c0 48 c7 c7 38 3f a7 81 e8 1e 34 e0 ff 0f ff 31 c0 5d c3 48 89 fe 31 c0 48 c7 c7 e8 3f a7 81 e8 07 34 e0 ff <0f> ff 31 c0 5d c3 48 89 fe 31 c0 48 c7 c7 a8 3f a7 81 e8 f0 33 
[  117.803715] ---[ end trace 06a87dde16f89e24 ]---
[  117.804948] general protection fault: 0000 [#1] SMP
[  117.806233] Modules linked in: dax_pmem(O) device_dax(O) nd_pmem(O) nd_blk(O) nd_btt(O) nfit_test(O-) nfit(O) libnvdimm(O) nfit_test_iomap(O) rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache sunrpc ppdev parport_pc pcspkr i2c_piix4 parport floppy i2c_core virtio_net virtio_balloon acpi_cpufreq sch_fq_codel ip_tables xfs libcrc32c sr_mod cdrom ata_generic pata_acpi virtio_console virtio_blk ata_piix libata virtio_pci crc32c_intel virtio_ring serio_raw virtio
[  117.818454] CPU: 4 PID: 2233 Comm: lt-libndctl Tainted: G        W  O    4.12.0-rc1+ #12
[  117.820866] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  117.822487] task: ffff88041d685500 task.stack: ffffc90002b50000
[  117.824178] RIP: 0010:__list_del_entry_valid+0x29/0xa0
[  117.825647] RSP: 0018:ffffc90002b53d60 EFLAGS: 00010887
[  117.827130] RAX: 6d726f6674616c70 RBX: 6d726f6674616c70 RCX: dead000000000200
[  117.829142] RDX: 65745f7469666e3a RSI: ffffc90002b53d98 RDI: ffffc9001700e000
[  117.831266] RBP: ffffc90002b53d60 R08: 00000000fffffffe R09: ffffc9001700e000
[  117.833276] R10: 0000000000000005 R11: ffff88041cac41c0 R12: ffffc90002b53d98
[  117.835285] R13: 6d726f6674616c70 R14: 0000000000000000 R15: ffff88041beefc08
[  117.837285] FS:  00007f7d70082c80(0000) GS:ffff880433100000(0000) knlGS:0000000000000000
[  117.839579] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  117.841230] CR2: 000055c0db522cc0 CR3: 0000000422156000 CR4: 00000000000006e0
[  117.843262] Call Trace:
[  117.843985]  release_nodes+0x76/0x260
[  117.845062]  devres_release_all+0x3c/0x50
[  117.846225]  device_release_driver_internal+0x159/0x200
[  117.847748]  device_release_driver+0x12/0x20
[  117.849029]  bus_remove_device+0xfd/0x170
[  117.850192]  device_del+0x1e8/0x330
[  117.851284]  platform_device_del+0x28/0x90
[  117.852485]  platform_device_unregister+0x12/0x30
[  117.853846]  nfit_test_exit+0x2a/0x93b [nfit_test]
[  117.855219]  SyS_delete_module+0x171/0x250
[  117.856403]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[  117.857769] RIP: 0033:0x7f7d6f399487
[  117.858809] RSP: 002b:00007ffc604502a8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[  117.860877] RAX: ffffffffffffffda RBX: 0000000002000000 RCX: 00007f7d6f399487
[  117.862752] RDX: 00000000000000e8 RSI: 0000000000000800 RDI: 00000000020838f8
[  117.864645] RBP: 00007ffc6044fc60 R08: 000000000208fb00 R09: 0000000000000037
[  117.866495] R10: 000000000000006d R11: 0000000000000206 R12: 0000000000404e60
[  117.868359] R13: 00007ffc60450440 R14: 0000000000000000 R15: 0000000000000000
[  117.870242] Code: 00 00 55 48 8b 07 48 b9 00 01 00 00 00 00 ad de 48 8b 57 08 48 89 e5 48 39 c8 74 27 48 b9 00 02 00 00 00 00 ad de 48 39 ca 74 60 <48> 8b 12 48 39 d7 75 41 48 8b 50 08 48 39 d7 75 21 b8 01 00 00 
[  117.875198] RIP: __list_del_entry_valid+0x29/0xa0 RSP: ffffc90002b53d60

----
Yasunori Goto

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
