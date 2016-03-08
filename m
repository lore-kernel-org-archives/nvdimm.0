Return-Path: <linux-kernel-owner@vger.kernel.org>
From: NeilBrown <neilb@suse.com>
Date: Wed, 09 Mar 2016 09:21:54 +1100
Subject: [PATCH] pmem: don't allocate unused major device number
Message-ID: <87k2lclif1.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


When alloc_disk(0) or alloc_disk-node(0, XX) is used, the ->major
number is completely ignored:  all devices are allocated with a
major of BLOCK_EXT_MAJOR.

So there is no point allocating pmem_major.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/nvdimm/pmem.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

Hi Dan et al,
 I was recently educating myself about the behavior of alloc_disk(0).
 As I understand it, the ->major is ignored and all device numbers for all
 partitions (including '0') are allocated on demand with major number of
 BLOCK_EXT_MAJOR.

 So I was a little surprised to find that pmem.c allocated a major
 number which is never used - historical anomaly I suspect.
 I was a bit more surprised at the comment in:

  Commit: 9f53f9fa4ad1 ("libnvdimm, pmem: add libnvdimm support to the pmem=
 driver")

 "The minor numbers are also more predictable by passing 0 to alloc_disk()."

 How can they possibly be more predictable given that they are allocated
 on-demand?  Maybe discovery order is very predictable???

 In any case, I propose this patch but cannot test it (beyond compiling)
 as I don't have relevant hardware.  And maybe some user-space code greps
 /proc/devices for "pmem" to determine if "pmem" is compiled in (though
 I sincerely hope not).
 So I cannot be certain that this patch won't break anything, but am
 hoping that if you like it you might test it.

 If it does prove acceptable, then similar changes would be appropriate
 for btt.c and blk.c.   And drivers/memstick/core/ms_block.c and
 drivers/nvme/host/core.c. (gotta stamp out this cargo cult)

 drivers/lightnvm/core.c is the only driver which uses alloc_disk(0) and
 doesn't provide a 'major' number. :-(

Thanks,
NeilBrown


diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 8d0b54670184..ec7e9e6a768e 100644
=2D-- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -47,8 +47,6 @@ struct pmem_device {
 	struct badblocks	bb;
 };
=20
=2Dstatic int pmem_major;
=2D
 static bool is_bad_pmem(struct badblocks *bb, sector_t sector, unsigned in=
t len)
 {
 	if (bb->count) {
@@ -228,8 +226,6 @@ static int pmem_attach_disk(struct device *dev,
 		return -ENOMEM;
 	}
=20
=2D	disk->major		=3D pmem_major;
=2D	disk->first_minor	=3D 0;
 	disk->fops		=3D &pmem_fops;
 	disk->private_data	=3D pmem;
 	disk->queue		=3D pmem->pmem_queue;
@@ -502,26 +498,13 @@ static struct nd_device_driver nd_pmem_driver =3D {
=20
 static int __init pmem_init(void)
 {
=2D	int error;
=2D
=2D	pmem_major =3D register_blkdev(0, "pmem");
=2D	if (pmem_major < 0)
=2D		return pmem_major;
=2D
=2D	error =3D nd_driver_register(&nd_pmem_driver);
=2D	if (error) {
=2D		unregister_blkdev(pmem_major, "pmem");
=2D		return error;
=2D	}
=2D
=2D	return 0;
+	return nd_driver_register(&nd_pmem_driver);
 }
 module_init(pmem_init);
=20
 static void pmem_exit(void)
 {
 	driver_unregister(&nd_pmem_driver.drv);
=2D	unregister_blkdev(pmem_major, "pmem");
 }
 module_exit(pmem_exit);
=20
=2D-=20
2.7.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW31CCAAoJEDnsnt1WYoG5/akP/016iTedEN6HqNhAWOYB9hWt
IAQA3JqZlo33HhNXfRia1ZqywHsyouwBzcXJ4Qzcnv+8pQR5P6iLGkLUHZq2z8qp
+YZDdxVT3mWDWJF5ArRsX0RU78lLMxIGQnS2a253lwIzKgTahbMxKx2NtbHhSQVU
U4AobsmCQNCkw56fvZTdPDexuUzLpXYGoby5b8kdtpwv2nTyBp7scfnJtpKgCnN2
CbkwCpkNLgCMNxkWmiPV1VW8RCNUCsvtVRIbU/BWpnsAFNapLhh7rksSjwc+8oEj
VeZkg4+/k7kqS/DwVchi59Kb65De4NlHKvcyY2zAVfG16iWG7uDAWUe/scknbRyQ
+/EfvmogkHQCiMrE7lqiH6YD/tiQbxjJD8yAvZYQQvWtpUNTWkgYbal4+gAsckNh
jSBj4XHlcDw14P9Mr8ILDNSkRJ2kNzsDpE811YbbXrlrNxgGc9nL2h4V2s/pEd2p
QiWSeSrxj6Ef8PEBDqhSNZOh8vCuL+celTvixTDdoBuG8SvSZr0/zOEwTvLVToZw
mdyGdenRKH2jFhLj+7Nnc+BWqzMQMnW6Hxb86NHrevLzmmj1K0DISkbN1RVWc3dp
imBrIaPSGLs2yPW9TvazATqqAmUG/al+ZaMcBrAgLZ4w6rcDEjTHJyEAUm/gOpws
NP4LfPLZNYZNUhyrKBhm
=7Lgp
-----END PGP SIGNATURE-----
--=-=-=--
