Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 29 Jun 2016 17:31:14 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: test suite errors
Message-ID: <20160629153114.4bbvee5zftre2lcc@c203.arch.suse.de>
References: <20160628082257.4z6tfucszvebhzus@c203.arch.suse.de>
 <CAPcyv4gH32tGM-YHVYwm1FuNp9GAerOKjpoPS6eAwNVZberPPQ@mail.gmail.com>
 <57732FB2.8010408@redhat.com>
 <CAPcyv4ihATMhz9YK_zs1krakENJxrumHrGP=GP-01NXSSRuXqA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4ihATMhz9YK_zs1krakENJxrumHrGP=GP-01NXSSRuXqA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 28, 2016 at 07:24:17PM -0700, Dan Williams wrote:
> On Tue, Jun 28, 2016 at 7:17 PM, yizhan <yizhan@redhat.com> wrote:
> > On 06/29/2016 12:26 AM, Dan Williams wrote:
> >> Do you have CONFIG_DEV_DAX_PMEM=3Dm?
> >>
> > I also met this error with CONFIG_DEV_DAX_PMEM=3Dm
> > Detailed log I have post at the last comment at
> > https://github.com/pmem/ndctl/issues/3
> =

> Can you re-run the test with kernel debugging enabled and piping the
> test messages to the kernel buffer.
> =

> Add the following to the kernel command line:
> =

>     libnvdimm.dyndbg nfit.dyndbg nd_pmem.dyndbg nd_btt.dyndbg
> dax_pmem.dyndbg dax.dyndbg
> =

> Specify add --enable-test when configuring ndctl and then run:
> =

>     ndctl test 2>/dev/kmsg
> =

> ...and send the log?

Here's the log. I did a dmesg -C to clear off all old stuff beforehand.

Thanks for looking into it.


[ 2731.036563] nfit_test nfit_test.0: add_spa: spa index: 1 type: pmem
[ 2731.036571] nfit_test nfit_test.0: add_spa: spa index: 2 type: pmem
[ 2731.036574] nfit_test nfit_test.0: add_spa: spa index: 3 type: dimm-cont=
rol-region
[ 2731.036577] nfit_test nfit_test.0: add_spa: spa index: 4 type: dimm-cont=
rol-region
[ 2731.036580] nfit_test nfit_test.0: add_spa: spa index: 5 type: dimm-cont=
rol-region
[ 2731.036583] nfit_test nfit_test.0: add_spa: spa index: 6 type: dimm-cont=
rol-region
[ 2731.036586] nfit_test nfit_test.0: add_spa: spa index: 7 type: block-dat=
a-window
[ 2731.036588] nfit_test nfit_test.0: add_spa: spa index: 8 type: block-dat=
a-window
[ 2731.036591] nfit_test nfit_test.0: add_spa: spa index: 9 type: block-dat=
a-window
[ 2731.036594] nfit_test nfit_test.0: add_spa: spa index: 10 type: block-da=
ta-window
[ 2731.036598] nfit_test nfit_test.0: add_memdev: memdev handle: 0x0 spa: 1=
 dcr: 5
[ 2731.036602] nfit_test nfit_test.0: add_memdev: memdev handle: 0x1 spa: 1=
 dcr: 6
[ 2731.036604] nfit_test nfit_test.0: add_memdev: memdev handle: 0x0 spa: 2=
 dcr: 5
[ 2731.036607] nfit_test nfit_test.0: add_memdev: memdev handle: 0x1 spa: 2=
 dcr: 6
[ 2731.036610] nfit_test nfit_test.0: add_memdev: memdev handle: 0x100 spa:=
 2 dcr: 7
[ 2731.036613] nfit_test nfit_test.0: add_memdev: memdev handle: 0x101 spa:=
 2 dcr: 8
[ 2731.036615] nfit_test nfit_test.0: add_memdev: memdev handle: 0x0 spa: 3=
 dcr: 1
[ 2731.036618] nfit_test nfit_test.0: add_memdev: memdev handle: 0x1 spa: 4=
 dcr: 2
[ 2731.036621] nfit_test nfit_test.0: add_memdev: memdev handle: 0x100 spa:=
 5 dcr: 3
[ 2731.036623] nfit_test nfit_test.0: add_memdev: memdev handle: 0x101 spa:=
 6 dcr: 4
[ 2731.036626] nfit_test nfit_test.0: add_memdev: memdev handle: 0x0 spa: 7=
 dcr: 1
[ 2731.036629] nfit_test nfit_test.0: add_memdev: memdev handle: 0x1 spa: 8=
 dcr: 2
[ 2731.036631] nfit_test nfit_test.0: add_memdev: memdev handle: 0x100 spa:=
 9 dcr: 3
[ 2731.036634] nfit_test nfit_test.0: add_memdev: memdev handle: 0x101 spa:=
 10 dcr: 4
[ 2731.036637] nfit_test nfit_test.0: add_dcr: dcr index: 1 windows: 1
[ 2731.036639] nfit_test nfit_test.0: add_dcr: dcr index: 2 windows: 1
[ 2731.036641] nfit_test nfit_test.0: add_dcr: dcr index: 3 windows: 1
[ 2731.036644] nfit_test nfit_test.0: add_dcr: dcr index: 4 windows: 1
[ 2731.036646] nfit_test nfit_test.0: add_dcr: dcr index: 5 windows: 0
[ 2731.036649] nfit_test nfit_test.0: add_dcr: dcr index: 6 windows: 0
[ 2731.036651] nfit_test nfit_test.0: add_dcr: dcr index: 7 windows: 0
[ 2731.036654] nfit_test nfit_test.0: add_dcr: dcr index: 8 windows: 0
[ 2731.036656] nfit_test nfit_test.0: add_bdw: bdw dcr: 1 windows: 1
[ 2731.036659] nfit_test nfit_test.0: add_bdw: bdw dcr: 2 windows: 1
[ 2731.036661] nfit_test nfit_test.0: add_bdw: bdw dcr: 3 windows: 1
[ 2731.036663] nfit_test nfit_test.0: add_bdw: bdw dcr: 4 windows: 1
[ 2731.036666] nfit_test nfit_test.0: add_flush: nfit_flush handle: 0 hint_=
count: 1
[ 2731.036669] nfit_test nfit_test.0: add_flush: nfit_flush handle: 1 hint_=
count: 1
[ 2731.036672] nfit_test nfit_test.0: add_flush: nfit_flush handle: 256 hin=
t_count: 1
[ 2731.036674] nfit_test nfit_test.0: add_flush: nfit_flush handle: 257 hin=
t_count: 1
[ 2731.036677] nfit_test nfit_test.0: found a zero length table '0' parsing=
 nfit
[ 2731.037003] nvdimm nmem9: nvdimm_init_config_data: len: 131072 rc: 0
[ 2731.037007] nvdimm nmem9: config data size: 131072
[ 2731.037011] nvdimm nmem9: nd_label_validate: nsindex0 signature invalid
[ 2731.037013] nvdimm nmem9: nd_label_validate: nsindex1 signature invalid
[ 2731.037016] nvdimm nmem8: nvdimm_init_config_data: len: 131072 rc: 0
[ 2731.037019] nvdimm nmem8: config data size: 131072
[ 2731.037025] nvdimm nmem8: nd_label_validate: nsindex0 signature invalid
[ 2731.037030] nvdimm nmem8: nd_label_validate: nsindex1 signature invalid
[ 2731.037036]  ndbus1: nvdimm.probe(nmem9) =3D 0
[ 2731.037038]  ndbus1: nvdimm.probe(nmem8) =3D 0
[ 2731.037129] nvdimm nmem10: nvdimm_init_config_data: len: 131072 rc: 0
[ 2731.037135] nvdimm nmem10: config data size: 131072
[ 2731.037138] nvdimm nmem10: nd_label_validate: nsindex0 signature invalid
[ 2731.037141] nvdimm nmem10: nd_label_validate: nsindex1 signature invalid
[ 2731.037144]  ndbus1: nvdimm.probe(nmem10) =3D 0
[ 2731.037196] nvdimm nmem11: nvdimm_init_config_data: len: 131072 rc: 0
[ 2731.037202] nvdimm nmem11: config data size: 131072
[ 2731.037205] nvdimm nmem11: nd_label_validate: nsindex0 signature invalid
[ 2731.037208] nvdimm nmem11: nd_label_validate: nsindex1 signature invalid
[ 2731.037211]  ndbus1: nvdimm.probe(nmem11) =3D 0
[ 2731.037228]  ndbus1: nvdimm_bus_check_dimm_count: count: 4
[ 2731.037313] nfit_test nfit_test.0: add_dcr: dcr index: 9 windows: 1
[ 2731.037316] nfit_test nfit_test.0: add_dcr: dcr index: 10 windows: 0
[ 2731.037319] nfit_test nfit_test.0: add_bdw: bdw dcr: 9 windows: 1
[ 2731.037322] nfit_test nfit_test.0: add_spa: spa index: 11 type: dimm-con=
trol-region
[ 2731.037325] nfit_test nfit_test.0: add_spa: spa index: 12 type: pmem
[ 2731.037328] nfit_test nfit_test.0: add_spa: spa index: 13 type: block-da=
ta-window
[ 2731.037332] nfit_test nfit_test.0: add_memdev: memdev handle: 0x1000 spa=
: 11 dcr: 9
[ 2731.037335] nfit_test nfit_test.0: add_memdev: memdev handle: 0x1000 spa=
: 12 dcr: 10
[ 2731.037337] nfit_test nfit_test.0: add_memdev: memdev handle: 0x1000 spa=
: 13 dcr: 9
[ 2731.037402] nvdimm nmem8: init_active_labels: 0
[ 2731.037406] nd_region region8: create_namespace_blk: discovered 0 blk na=
mespaces
[ 2731.037430] nvdimm nmem9: init_active_labels: 0
[ 2731.037433] nd_region region9: create_namespace_blk: discovered 0 blk na=
mespaces
[ 2731.037439]  ndbus1: nd_region.probe(region8) =3D 0
[ 2731.037469]  ndbus1: nd_region.probe(region9) =3D 0
[ 2731.037477] nvdimm nmem10: init_active_labels: 0
[ 2731.037483] nd_region region10: create_namespace_blk: discovered 0 blk n=
amespaces
[ 2731.037494] nvdimm nmem11: init_active_labels: 0
[ 2731.037497] nd_region region11: create_namespace_blk: discovered 0 blk n=
amespaces
[ 2731.037517]  ndbus1: nd_region.probe(region10) =3D 0
[ 2731.037536]  ndbus1: nd_region.probe(region11) =3D 0
[ 2731.037863] nvdimm nmem12: nvdimm_init_config_data: len: 131072 rc: 0
[ 2731.037869] nvdimm nmem12: config data size: 131072
[ 2731.037872] nvdimm nmem12: nd_label_validate: nsindex0 signature invalid
[ 2731.037874] nvdimm nmem12: nd_label_validate: nsindex1 signature invalid
[ 2731.037878]  ndbus1: nvdimm.probe(nmem12) =3D 0
[ 2731.037897]  ndbus1: nvdimm_bus_check_dimm_count: count: 5
[ 2731.038052] nd_region region12: unable to guarantee persistence of writes
[ 2731.038055] nvdimm nmem12: init_active_labels: 0
[ 2731.038059] nd_region region12: create_namespace_blk: discovered 0 blk n=
amespaces
[ 2731.038084]  ndbus1: nd_region.probe(region12) =3D 0
[ 2731.049242] nd_blk namespace8.0: 0x0000000000000000, too small must be a=
t least 0x400000
[ 2731.049250]  ndbus1: nd_blk.probe(namespace8.0) =3D -19
[ 2731.049264]  ndbus1: nd_blk.probe(btt8.0) =3D -19
[ 2731.049275]  ndbus1: nd_blk.probe(btt9.0) =3D -19
[ 2731.049284] nd_blk namespace9.0: 0x0000000000000000, too small must be a=
t least 0x400000
[ 2731.049286]  ndbus1: nd_blk.probe(namespace9.0) =3D -19
[ 2731.049296] nd_blk namespace10.0: 0x0000000000000000, too small must be =
at least 0x400000
[ 2731.049298]  ndbus1: nd_blk.probe(namespace10.0) =3D -19
[ 2731.049307]  ndbus1: nd_blk.probe(btt10.0) =3D -19
[ 2731.049315]  ndbus1: nd_blk.probe(btt11.0) =3D -19
[ 2731.049323] nd_blk namespace11.0: 0x0000000000000000, too small must be =
at least 0x400000
[ 2731.049327]  ndbus1: nd_blk.probe(namespace11.0) =3D -19
[ 2731.049338] nd_blk namespace12.0: 0x0000000000000000, too small must be =
at least 0x400000
[ 2731.049340]  ndbus1: nd_blk.probe(namespace12.0) =3D -19
[ 2731.049349]  ndbus1: nd_blk.probe(btt12.0) =3D -19
[ 2731.061136] nfit_test nfit_test.1: add_spa: spa index: 1 type: pmem
[ 2731.061144] nfit_test nfit_test.1: add_memdev: memdev handle: 0x0 spa: 1=
 dcr: 1
[ 2731.061148] nfit_test nfit_test.1: add_dcr: dcr index: 1 windows: 0
[ 2731.061162] nfit_test nfit_test.1: nmem13 flags: save_fail restore_fail =
flush_fail not_armed
[ 2731.061335] nvdimm nmem13: nvdimm_init_nsarea [libnvdimm]: validate_dimm=
 error: -6
[ 2731.061341] nvdimm nmem13: nvdimm_drvdata_release
[ 2731.061346]  ndbus2: nvdimm.probe(nmem13) =3D -6
[ 2731.061363]  ndbus2: nvdimm_bus_check_dimm_count: count: 1
[ 2732.041824] nfit_test nfit_test.0: init scrub 0x186ff00000 + 0x2000000 c=
omplete
[ 2732.042047] nvdimm nmem8: init_active_labels: 0
[ 2732.042053] nvdimm nmem9: init_active_labels: 0
[ 2732.042057] nd_region region13: find_pmem_label_set: label not found
[ 2732.042087] nvdimm nmem12: init_active_labels: 0
[ 2732.042092] nd_region region15: find_pmem_label_set: label not found
[ 2732.042099] nvdimm nmem8: init_active_labels: 0
[ 2732.042105] nvdimm nmem9: init_active_labels: 0
[ 2732.042109] nvdimm nmem10: init_active_labels: 0
[ 2732.042112] nvdimm nmem11: init_active_labels: 0
[ 2732.042116] nd_region region14: find_pmem_label_set: label not found
[ 2732.042120]  ndbus1: nd_region.probe(region13) =3D 0
[ 2732.042152]  ndbus1: nd_region.probe(region15) =3D 0
[ 2732.042183]  ndbus1: nd_region.probe(region14) =3D 0
[ 2732.042247] nd_pmem namespace13.0: 0x0000000000000000, too small must be=
 at least 0x400000
[ 2732.042254]  ndbus1: nd_pmem.probe(namespace13.0) =3D -19
[ 2732.042279]  ndbus1: nd_pmem.probe(btt13.0) =3D -19
[ 2732.042382]  ndbus1: nd_pmem.probe(pfn13.0) =3D -19
[ 2732.042384] nd_pmem namespace15.0: 0x0000000000000000, too small must be=
 at least 0x400000
[ 2732.042389]  ndbus1: nd_pmem.probe(namespace15.0) =3D -19
[ 2732.042431]  ndbus1: nd_pmem.probe(btt15.0) =3D -19
[ 2732.042449]  ndbus1: dax_pmem.probe(dax13.0) =3D -19
[ 2732.042504]  ndbus1: nd_pmem.probe(btt14.0) =3D -19
[ 2732.042517]  ndbus1: nd_pmem.probe(pfn15.0) =3D -19
[ 2732.042547] nd_pmem namespace14.0: 0x0000000000000000, too small must be=
 at least 0x400000
[ 2732.042553]  ndbus1: nd_pmem.probe(namespace14.0) =3D -19
[ 2732.042570]  ndbus1: dax_pmem.probe(dax15.0) =3D -19
[ 2732.042572]  ndbus1: dax_pmem.probe(dax14.0) =3D -19
[ 2732.042597]  ndbus1: nd_pmem.probe(pfn14.0) =3D -19
[ 2733.045862] nfit_test nfit_test.0: spa range: 2 ars from 0x1871f00000 + =
0x4000000 complete
[ 2734.049915] nfit_test nfit_test.0: spa range: 12 ars from 0x1875f00000 +=
 0x2000000 complete
[ 2734.049925] nfit_test nfit_test.0: init scrub 0x1875f00000 + 0x2000000 c=
omplete
[ 2734.049936] nfit_test nfit_test.1: init scrub 0x1877f00000 + 0x2000000 c=
omplete
[ 2734.050124]  ndbus2: nd_region.probe(region16) =3D 0
[ 2734.050247]  ndbus2: nd_pmem.probe(btt16.0) =3D -19
[ 2734.050274] nd_pmem namespace16.0: Found a poison range (0x1000000, 0x10=
00)
[ 2734.050282]  ndbus2: nd_pmem.probe(pfn16.0) =3D -19
[ 2734.050288]  ndbus2: dax_pmem.probe(dax16.0) =3D -19
[ 2734.050295] nd_pmem namespace16.0: nd_btt_probe: btt: <none>
[ 2734.050299]  btt16.1: nd_btt_release
[ 2734.050311] nd_pmem namespace16.0: nd_pfn_probe: pfn: <none>
[ 2734.050314]  pfn16.1: nd_pfn_release
[ 2734.050325] nd_pmem namespace16.0: nd_dax_probe: dax: <none>
[ 2734.050327]  dax16.1: nd_dax_release
[ 2734.050332] nd_pmem namespace16.0: unable to guarantee persistence of wr=
ites
[ 2734.050604] nd_pmem namespace16.0: Found a poison range (0x1000000, 0x10=
00)
[ 2734.050785] nd_pmem namespace16.0: region16 read-only, marking pmem16 re=
ad-only
[ 2734.051046] pmem16: detected capacity change from 0 to 33554432
[ 2734.051054]  ndbus2: nd_pmem.probe(namespace16.0) =3D 0
[ 2734.052732] nd btt15.0: nd_btt_release
[ 2734.052769] nd pfn15.0: nd_pfn_release
[ 2734.052796] nd dax15.0: nd_dax_release
[ 2734.052800]  ndbus1: nd_region.remove(region15) =3D 0
[ 2734.053113] nd btt14.0: nd_btt_release
[ 2734.053251] nd dax14.0: nd_dax_release
[ 2734.053383] nd pfn14.0: nd_pfn_release
[ 2734.053388]  ndbus1: nd_region.remove(region14) =3D 0
[ 2734.054257] nd btt13.0: nd_btt_release
[ 2734.054425] nd pfn13.0: nd_pfn_release
[ 2734.054524] nd dax13.0: nd_dax_release
[ 2734.054528]  ndbus1: nd_region.remove(region13) =3D 0
[ 2734.055636] nd btt12.0: nd_btt_release
[ 2734.055644] nfit_test nfit_test.0: nfit_spa_mapping_release: SPA13
[ 2734.055649] nfit_test nfit_test.0: nfit_spa_mapping_release: SPA11
[ 2734.055652]  ndbus1: nd_region.remove(region12) =3D 0
[ 2734.057205] nd btt11.0: nd_btt_release
[ 2734.057210] nfit_test nfit_test.0: nfit_spa_mapping_release: SPA10
[ 2734.057215] nfit_test nfit_test.0: nfit_spa_mapping_release: SPA6
[ 2734.057218]  ndbus1: nd_region.remove(region11) =3D 0
[ 2734.058525] nd btt10.0: nd_btt_release
[ 2734.058531] nfit_test nfit_test.0: nfit_spa_mapping_release: SPA9
[ 2734.058535] nfit_test nfit_test.0: nfit_spa_mapping_release: SPA5
[ 2734.058538]  ndbus1: nd_region.remove(region10) =3D 0
[ 2734.059293] nd btt9.0: nd_btt_release
[ 2734.059397] nfit_test nfit_test.0: nfit_spa_mapping_release: SPA8
[ 2734.059402] nfit_test nfit_test.0: nfit_spa_mapping_release: SPA4
[ 2734.059404]  ndbus1: nd_region.remove(region9) =3D 0
[ 2734.060040] nd btt8.0: nd_btt_release
[ 2734.060044] nfit_test nfit_test.0: nfit_spa_mapping_release: SPA7
[ 2734.060049] nfit_test nfit_test.0: nfit_spa_mapping_release: SPA3
[ 2734.060052]  ndbus1: nd_region.remove(region8) =3D 0
[ 2734.062164] check_smart: HAVE_NDCTL_SMART disabled, skipping
[ 2734.062169] check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
[ 2734.063393] check_set_config_data: dimm: 0 read2 data miscompare: 0
[ 2735.063633] check_smart: HAVE_NDCTL_SMART disabled, skipping
[ 2735.063639] check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
[ 2735.064647] check_set_config_data: dimm: 0x1 read2 data miscompare: 0
[ 2736.064816] check_smart: HAVE_NDCTL_SMART disabled, skipping
[ 2736.064823] check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
[ 2736.065782] check_set_config_data: dimm: 0x100 read2 data miscompare: 0
[ 2737.065952] check_smart: HAVE_NDCTL_SMART disabled, skipping
[ 2737.065959] check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
[ 2737.066994] check_set_config_data: dimm: 0x101 read2 data miscompare: 0
[ 2738.067864] nvdimm nmem12: nvdimm_drvdata_release
[ 2738.067871]  ndbus1: nvdimm.remove(nmem12) =3D 0
[ 2738.068133] nvdimm nmem12: nvdimm_init_config_data: len: 131072 rc: 0
[ 2738.068137] nvdimm nmem12: config data size: 131072
[ 2738.068140] nvdimm nmem12: nd_label_validate: nsindex0 signature invalid
[ 2738.068142] nvdimm nmem12: nd_label_validate: nsindex1 signature invalid
[ 2738.068146]  ndbus1: nvdimm.probe(nmem12) =3D 0
[ 2738.068760] nvdimm nmem11: nvdimm_drvdata_release
[ 2738.068764]  ndbus1: nvdimm.remove(nmem11) =3D 0
[ 2738.068975] nvdimm nmem11: nvdimm_init_config_data: len: 131072 rc: 0
[ 2738.068978] nvdimm nmem11: config data size: 131072
[ 2738.068981] nvdimm nmem11: nd_label_validate: nsindex0 signature invalid
[ 2738.068983] nvdimm nmem11: nd_label_validate: nsindex1 signature invalid
[ 2738.068985]  ndbus1: nvdimm.probe(nmem11) =3D 0
[ 2738.069552] nvdimm nmem10: nvdimm_drvdata_release
[ 2738.069556]  ndbus1: nvdimm.remove(nmem10) =3D 0
[ 2738.069766] nvdimm nmem10: nvdimm_init_config_data: len: 131072 rc: 0
[ 2738.069769] nvdimm nmem10: config data size: 131072
[ 2738.069771] nvdimm nmem10: nd_label_validate: nsindex0 signature invalid
[ 2738.069773] nvdimm nmem10: nd_label_validate: nsindex1 signature invalid
[ 2738.069776]  ndbus1: nvdimm.probe(nmem10) =3D 0
[ 2738.070373] nvdimm nmem9: nvdimm_drvdata_release
[ 2738.070377]  ndbus1: nvdimm.remove(nmem9) =3D 0
[ 2738.070604] nvdimm nmem9: nvdimm_init_config_data: len: 131072 rc: 0
[ 2738.070607] nvdimm nmem9: config data size: 131072
[ 2738.070609] nvdimm nmem9: nd_label_validate: nsindex0 signature invalid
[ 2738.070611] nvdimm nmem9: nd_label_validate: nsindex1 signature invalid
[ 2738.070614]  ndbus1: nvdimm.probe(nmem9) =3D 0
[ 2738.071214] nvdimm nmem8: nvdimm_drvdata_release
[ 2738.071217]  ndbus1: nvdimm.remove(nmem8) =3D 0
[ 2738.071441] nvdimm nmem8: nvdimm_init_config_data: len: 131072 rc: 0
[ 2738.071444] nvdimm nmem8: config data size: 131072
[ 2738.071447] nvdimm nmem8: nd_label_validate: nsindex0 signature invalid
[ 2738.071449] nvdimm nmem8: nd_label_validate: nsindex1 signature invalid
[ 2738.071452]  ndbus1: nvdimm.probe(nmem8) =3D 0
[ 2738.071659] nvdimm nmem12: init_active_labels: 0
[ 2738.071664] nd_region region15: find_pmem_label_set: label not found
[ 2738.071689]  ndbus1: nd_region.probe(region15) =3D 0
[ 2738.071771] nd_pmem namespace15.0: 0x0000000000000000, too small must be=
 at least 0x400000
[ 2738.071777]  ndbus1: nd_pmem.probe(namespace15.0) =3D -19
[ 2738.071797]  ndbus1: nd_pmem.probe(btt15.0) =3D -19
[ 2738.071880]  ndbus1: nd_pmem.probe(pfn15.0) =3D -19
[ 2738.071894]  ndbus1: dax_pmem.probe(dax15.0) =3D -19
[ 2738.072081] nvdimm nmem8: init_active_labels: 0
[ 2738.072084] nvdimm nmem9: init_active_labels: 0
[ 2738.072087] nvdimm nmem10: init_active_labels: 0
[ 2738.072089] nvdimm nmem11: init_active_labels: 0
[ 2738.072092] nd_region region14: find_pmem_label_set: label not found
[ 2738.072116]  ndbus1: nd_region.probe(region14) =3D 0
[ 2738.072248]  ndbus1: nd_pmem.probe(btt14.0) =3D -19
[ 2738.072252] nd_pmem namespace14.0: 0x0000000000000000, too small must be=
 at least 0x400000
[ 2738.072256]  ndbus1: nd_pmem.probe(namespace14.0) =3D -19
[ 2738.072298]  ndbus1: dax_pmem.probe(dax14.0) =3D -19
[ 2738.072315]  ndbus1: nd_pmem.probe(pfn14.0) =3D -19
[ 2738.072470] nvdimm nmem8: init_active_labels: 0
[ 2738.072474] nvdimm nmem9: init_active_labels: 0
[ 2738.072477] nd_region region13: find_pmem_label_set: label not found
[ 2738.072497]  ndbus1: nd_region.probe(region13) =3D 0
[ 2738.072619]  ndbus1: nd_pmem.probe(btt13.0) =3D -19
[ 2738.072640] nd_pmem namespace13.0: 0x0000000000000000, too small must be=
 at least 0x400000
[ 2738.072644]  ndbus1: nd_pmem.probe(namespace13.0) =3D -19
[ 2738.072671]  ndbus1: nd_pmem.probe(pfn13.0) =3D -19
[ 2738.072698]  ndbus1: dax_pmem.probe(dax13.0) =3D -19
[ 2738.072891] nd_region region12: unable to guarantee persistence of writes
[ 2738.072895] nvdimm nmem12: init_active_labels: 0
[ 2738.072899] nd_region region12: create_namespace_blk: discovered 0 blk n=
amespaces
[ 2738.072912]  ndbus1: nd_region.probe(region12) =3D 0
[ 2738.073057] nd_blk namespace12.0: 0x0000000000000000, too small must be =
at least 0x400000
[ 2738.073061]  ndbus1: nd_blk.probe(namespace12.0) =3D -19
[ 2738.073101]  ndbus1: nd_blk.probe(btt12.0) =3D -19
[ 2738.073360] nvdimm nmem11: init_active_labels: 0
[ 2738.073363] nd_region region11: create_namespace_blk: discovered 0 blk n=
amespaces
[ 2738.073374]  ndbus1: nd_region.probe(region11) =3D 0
[ 2738.073521]  ndbus1: nd_blk.probe(btt11.0) =3D -19
[ 2738.073538] nd_blk namespace11.0: 0x0000000000000000, too small must be =
at least 0x400000
[ 2738.073545]  ndbus1: nd_blk.probe(namespace11.0) =3D -19
[ 2738.073823] nvdimm nmem10: init_active_labels: 0
[ 2738.073826] nd_region region10: create_namespace_blk: discovered 0 blk n=
amespaces
[ 2738.073838]  ndbus1: nd_region.probe(region10) =3D 0
[ 2738.073982]  ndbus1: nd_blk.probe(btt10.0) =3D -19
[ 2738.074004] nd_blk namespace10.0: 0x0000000000000000, too small must be =
at least 0x400000
[ 2738.074007]  ndbus1: nd_blk.probe(namespace10.0) =3D -19
[ 2738.074205] nvdimm nmem9: init_active_labels: 0
[ 2738.074209] nd_region region9: create_namespace_blk: discovered 0 blk na=
mespaces
[ 2738.074228]  ndbus1: nd_region.probe(region9) =3D 0
[ 2738.074423]  ndbus1: nd_blk.probe(btt9.0) =3D -19
[ 2738.074438] nd_blk namespace9.0: 0x0000000000000000, too small must be a=
t least 0x400000
[ 2738.074442]  ndbus1: nd_blk.probe(namespace9.0) =3D -19
[ 2738.075072] nvdimm nmem8: init_active_labels: 0
[ 2738.075075] nd_region region8: create_namespace_blk: discovered 0 blk na=
mespaces
[ 2738.075090]  ndbus1: nd_region.probe(region8) =3D 0
[ 2738.075383]  ndbus1: nd_blk.probe(btt8.0) =3D -19
[ 2738.075537] nd_blk namespace8.0: 0x0000000000000000, too small must be a=
t least 0x400000
[ 2738.075544]  ndbus1: nd_blk.probe(namespace8.0) =3D -19
[ 2738.076789] nd btt13.0: nd_btt_release
[ 2738.077221] nd pfn13.0: nd_pfn_release
[ 2738.077540] nd dax13.0: nd_dax_release
[ 2738.077544]  ndbus1: nd_region.remove(region13) =3D 0
[ 2738.079207] nvdimm nmem8: init_active_labels: 0
[ 2738.079211] nvdimm nmem9: init_active_labels: 0
[ 2738.079214] nd_region region13: find_pmem_label_set: label not found
[ 2738.079239]  ndbus1: nd_region.probe(region13) =3D 0
[ 2738.079870]  ndbus1: nd_pmem.probe(pfn13.0) =3D -19
[ 2738.079928]  ndbus1: nd_pmem.probe(btt13.0) =3D -19
[ 2738.080009] nd_pmem namespace13.0: 0x0000000000000000, too small must be=
 at least 0x400000
[ 2738.080017]  ndbus1: nd_pmem.probe(namespace13.0) =3D -19
[ 2738.080110]  ndbus1: dax_pmem.probe(dax13.0) =3D -19
[ 2738.082758] nd namespace13.0: uuid_store: result: 0 wrote: 01010101-0101=
-0101-0101-010101010101
[ 2738.082848] nd namespace13.0: alt_name_store: (0)
[ 2738.083129] nd_region region13: nmem8: pmem-01010101: 0x900000 @ 0x0 ini=
t 0
[ 2738.083133] nd_region region13: nmem9: pmem-01010101: 0x900000 @ 0x0 ini=
t 0
[ 2738.083154] nvdimm nmem8: __pmem_label_update: allocated: 0
[ 2738.083173] nvdimm nmem9: __pmem_label_update: allocated: 0
[ 2738.083177] nd namespace13.0: size_store: 1200000 success (0)
[ 2738.083186] check_dax_create: 4
[ 2738.083725] __check_dax_create: dax13.0 align: 1
[ 2738.083754] nd dax13.0: uuid_store: result: 0 wrote: 01020304-0506-0700-=
0809-0a0b0c0d0e0f
[ 2738.083772] nd dax13.0: mode_store: result: 0 wrote: ram
[ 2738.083786] nd dax13.0: align_store: result: -22 wrote: 1
               =

[ 2738.083803] nd dax13.0: namespace_store: result: 14 wrote: namespace13.0
[ 2738.083900] dax_pmem dax13.0: Found a poison range (0x1000000, 0x1000)
[ 2738.084052]  ndbus1: dax_pmem.probe(dax13.0) =3D 0
[ 2738.084156]  ndbus1: dax_pmem.probe(dax13.1) =3D -19
[ 2738.085319] dax dax13.0: dax_dev_open
[ 2738.085325] dax dax13.0: dax_dev_release
[ 2738.085334] libdaxctl: daxctl_region_unref: region13 released
[ 2738.085404]  ndbus1: dax_pmem.remove(dax13.0) =3D 0
[ 2738.085408] dax dax13.0: unregister_dax_dev
[ 2738.102190] dax_pmem dax13.0: dax_pmem_percpu_kill
[ 2738.102196] dax_pmem dax13.0: dax_pmem_percpu_exit
[ 2738.126095] dax_pmem dax13.0: dax_pmem_percpu_release
[ 2738.126152] nd dax13.0: namespace_store: result: 2 wrote: =

               =

[ 2738.126235] nd dax13.0: nd_dax_release
[ 2738.126515] __check_dax_create: dax13.1 align: 1073741824
[ 2738.126533] nd dax13.1: uuid_store: result: 0 wrote: 01020304-0506-0700-=
0809-0a0b0c0d0e0f
[ 2738.126544] nd dax13.1: mode_store: result: 0 wrote: ram
[ 2738.126555] nd dax13.1: align_store: result: 0 wrote: 1073741824
               =

[ 2738.126568] nd dax13.1: namespace_store: result: 14 wrote: namespace13.0
[ 2738.126664] dax_pmem dax13.1: Found a poison range (0x1000000, 0x1000)
[ 2738.126673] dax_pmem dax13.1: alignment: 40000000 exceeds capacity 12000=
00
[ 2738.126677]  ndbus1: dax_pmem.probe(dax13.1) =3D -22
[ 2738.126683] dax_pmem: probe of dax13.1 failed with error -22
[ 2738.126792] libndctl: ndctl_dax_enable: dax13.1: failed to enable
[ 2738.126815] nd dax13.1: namespace_store: result: 2 wrote: =

               =

[ 2738.127047] __check_dax_create: dax13.1 align: 4096
[ 2738.127062] nd dax13.1: uuid_store: result: 0 wrote: 01020304-0506-0700-=
0809-0a0b0c0d0e0f
[ 2738.127072] nd dax13.1: mode_store: result: 0 wrote: ram
[ 2738.127082] nd dax13.1: align_store: result: 0 wrote: 4096
               =

[ 2738.127094] nd dax13.1: namespace_store: result: 14 wrote: namespace13.0
[ 2738.127178] dax_pmem dax13.1: Found a poison range (0x1000000, 0x1000)
[ 2738.127313]  ndbus1: dax_pmem.probe(dax13.1) =3D 0
[ 2738.127426]  ndbus1: dax_pmem.probe(dax13.0) =3D -19
[ 2738.128267] dax dax13.0: dax_dev_open
[ 2738.128272] dax dax13.0: dax_dev_release
[ 2738.128278] libdaxctl: daxctl_region_unref: region13 released
[ 2738.128320]  ndbus1: dax_pmem.remove(dax13.1) =3D 0
[ 2738.128323] dax dax13.0: unregister_dax_dev
[ 2738.142188] dax_pmem dax13.1: dax_pmem_percpu_kill
[ 2738.142194] dax_pmem dax13.1: dax_pmem_percpu_exit
[ 2738.166097] dax_pmem dax13.1: dax_pmem_percpu_release
[ 2738.166165] nd dax13.1: namespace_store: result: 2 wrote: =

               =

[ 2738.166261] nd dax13.1: nd_dax_release
[ 2738.166531] __check_dax_create: dax13.0 align: 2097152
[ 2738.166550] nd dax13.0: uuid_store: result: 0 wrote: 01020304-0506-0700-=
0809-0a0b0c0d0e0f
[ 2738.166560] nd dax13.0: mode_store: result: 0 wrote: ram
[ 2738.166571] nd dax13.0: align_store: result: 0 wrote: 2097152
               =

[ 2738.166584] nd dax13.0: namespace_store: result: 14 wrote: namespace13.0
[ 2738.166677] dax_pmem dax13.0: Found a poison range (0x1000000, 0x1000)
[ 2738.166691] dax_pmem dax13.0: bad offset: 0x100000 dax disabled
[ 2738.166694]  ndbus1: dax_pmem.probe(dax13.0) =3D -6
[ 2738.166802] libndctl: ndctl_dax_enable: dax13.0: failed to enable
[ 2738.166820] dax13.0: expected dax enable success, region13 read-write
[ 2738.166825] namespace13.0: failed to create dax
[ 2738.166828] namespace13.0: failed to configure namespace
[ 2738.166835] ndctl-test0 failed: -6
[ 2738.166847] libkmod: kmod_module_remove_module: could not remove 'nfit_t=
est': Resource temporarily unavailable
[ 2738.166867] libdaxctl: daxctl_unref: context 0x1aec410 released
[ 2738.166872] libndctl: ndctl_unref: context 0x1ae43d0 released
[ 2738.166910] test-libndctl: FAIL
-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
