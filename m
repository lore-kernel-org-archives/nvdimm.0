Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1864175A74;
	Sat, 29 Aug 2026 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788024346; cv=none; b=mB7Jy+5fyuabPX/bd+mWvivp/AffDUdMsDD/4g3mF4lQhKc+ceNjiVYgm+oxOBcyhML6LwLPUUqPhqrlAZQ78LJK7BSSG0gmssaVtSfFDvCyA6D0fsXjm0aCuW7jymlFJi+yCa0EUhHeuGMYGUCSdBEhemqhY8JIDht5c9UERBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788024346; c=relaxed/simple;
	bh=taWRS5KeDtfFk6RBi+GDlmg8KONhjy6N5llRWHXeXBo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dNnhjn0rf3sSVyULGeL2At9hQ+dYzQMXX/OxFLODRahYGzg3WZwdmrVDjl/rT5KVFS77KiAV0XzfxCzQqwZB7H2ILt69i5ldAwGB29EmwysN1PKAasRRYtOVB/uZh5Mj/QGYr2Y5np80Y5DxQq0FFUPE/tq0MhHly+2il6r7vvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBtRGZ5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBtRGZ5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676DE1F000E9;
	Sat, 29 Aug 2026 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788024344;
	bh=irWa7I6yV/b+sKfXv9qu9NLLbPQEh1hwqRNnkEo0Xdk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gBtRGZ5wJj3HGL/Fvq7OnfYBCG1Gi3aJl812ca+NrkhbLDFbpvj464Y2TN+sS68eX
	 n2aAoT8N8FGLjFBk3JPqO5YTP+bTwcIFM7YjGUpanQhF6UVZz8Okr9Q3aYYpvstNuD
	 g8a5cg2BTmPMo6pooIzJE7G3WYHYrdHF96YHtkIS6JIre3EqGMPlwcRPmBUfC8j9S3
	 wtXG9U74ISr3//h4SHfEhuK3rdUS86QmvXElubt1rQS061IxGWaalNiTbpptMq9Ybf
	 Ug9+5bh9GUn/t8w4xeJiHpVwCLdsELMkmIL9b9Gp21BWJFmjNM99G0Dd88fLDqkLLJ
	 J1FJXIUI4izng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V14 08/12] famfs: iomap_begin and file-to-dax offset
 resolution
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <010001a04e81ec26-3050ee4c-5ec4-4605-b16b-cdc208c1bd05-000000@email.amazonses.com>
References: <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
 <20260829171201.7482-1-john@jagalactic.com>
 <010001a04e81ec26-3050ee4c-5ec4-4605-b16b-cdc208c1bd05-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 17:25:44 +0000
Message-Id: <20260829172544.676DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:

New issues:
- [High] Missing read memory barrier in lockless daxdev lookup causes NULL =
pointer dereferences and uninitialized iomap returns.
- [High] Huge user-provided extent lengths can bypass overflow checks, wrap=
 to negative `loff_t`, and cause `iomap_begin` to return a negative length.
- [High] Concurrent lockless modification of latching error state (meta->er=
ror) from page fault paths.
- [High] Page fault path can observe partially initialized inode state due =
to missing synchronization.
- [Medium] Concurrent read of `dd->name` in `famfs_dax_err` while `dd->vali=
d =3D=3D 0` can dereference uncommitted or unmapped memory.
- [Medium] Un-ratelimited pr_warn in the I/O path can cause kernel log floo=
ding.
- [Low] Native 64-bit division and modulo operations cause build failures o=
n 32-bit architectures.

Pre-existing issues:
- [High] famfs_dax_read_iter manually advances iocb->ki_pos after dax_iomap=
_rw already advanced it.
--

commit b15edec08ab799f362ddce177190dc4582c58868
Author: John Groves <John@Groves.net>
Subject: famfs: iomap_begin and file-to-dax offset resolution

Add the iomap resolver that maps a file offset to a (daxdev, offset) pair.
Wires it into the read, write and fault paths by replacing their NULL
stub with &famfs_iomap_ops, so dax_iomap_rw() and dax_iomap_fault()
now resolve through famfs.

> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index f099e0d08673f..2200f168aa79d 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
> @@ -384,6 +384,305 @@ famfs_file_ioctl(struct file *file, unsigned int cm=
d, unsigned long arg)
[ ... ]
> +static int
> +famfs_dax_err(struct famfs_daxdev *dd)
> +{
> +	if (!dd->valid) {
> +		pr_debug("%s: daxdev=3D%s invalid\n", __func__, dd->name);

[Severity: Medium]
Can this race with daxdev initialization? A concurrent
famfs_install_daxdev() allocates dd->name via kstrdup() before setting
dd->valid =3D 1. Could a reader here observe the pointer but dereference
uncommitted string memory?

> +		return -EIO;
> +	}
[ ... ]
> +static struct dax_device *
> +famfs_daxdev_from_index(struct famfs_fs_info *fsi, u64 dev_index, int *e=
rrp)
> +{
[ ... ]
> +	dd =3D &devlist->devlist[dev_index];
> +	rc =3D famfs_dax_err(dd);
> +	if (rc) {
> +		*errp =3D rc;
> +		return NULL;
> +	}
> +	*errp =3D 0;
> +	return dd->devp;

[Severity: High]
Does this lockless read of dd->devp need an smp_rmb()?

The writer famfs_install_daxdev() uses a wmb() to order stores before
setting dd->valid =3D 1. If the reader reads dd->valid =3D=3D 1 in
famfs_dax_err(), could CPU reordering cause it to fetch a stale NULL
for dd->devp, returning NULL while setting *errp =3D 0?

> +}
> +
> +static int
> +famfs_meta_to_dax_offset_interleaved(
[ ... ]
> +		/* Is the data is in this striped extent? */
> +		if (local_offset < ext_size) {
> +			u64 chunk_num       =3D local_offset / chunk_size;
> +			u64 chunk_offset    =3D local_offset % chunk_size;
> +			u64 stripe_num      =3D chunk_num / nstrips;
> +			u64 strip_num       =3D chunk_num % nstrips;

[Severity: Low]
Will these native 64-bit division and modulo operations cause build
failures on 32-bit architectures? Should this use kernel math helpers
like div64_u64()?

> +			u64 chunk_remainder =3D chunk_size - chunk_offset;
> +			u64 strip_offset    =3D chunk_offset + (stripe_num * chunk_size);
> +			struct famfs_meta_simple_ext *strip =3D &fei->ie_strips[strip_num];
> +			struct dax_device *daxdev;
[ ... ]
> +			iomap->addr    =3D strip->ext_offset + strip_offset;
> +			iomap->offset  =3D file_offset;
> +			iomap->length  =3D min_t(loff_t, len, chunk_remainder);
> +			iomap->length  =3D min_t(loff_t, iomap->length,
> +					       strip->ext_len - strip_offset);

[Severity: High]
If a user provides a very large strip->ext_len that exceeds the maximum
signed loff_t (e.g. > 0x7FFFFFFFFFFFFFFF), will casting it to loff_t in
min_t() result in a negative number? Could this cause iomap->length to
become negative and break VFS iomap iterator invariants?

> +			iomap->dax_dev =3D daxdev;
> +			iomap->type    =3D IOMAP_MAPPED;
> +
> +			return 0;
[ ... ]
> +static int
> +famfs_meta_to_dax_offset(
[ ... ]
> +	for (i =3D 0; i < meta->fm_nextents; i++) {
> +		loff_t dax_ext_offset =3D meta->se[i].ext_offset;
> +		loff_t dax_ext_len    =3D meta->se[i].ext_len;
> +
> +		if ((dax_ext_offset =3D=3D 0) &&
> +		    (meta->file_type !=3D FAMFS_SUPERBLOCK))
> +			pr_warn("%s: zero offset on non-superblock file!!\n",
> +				__func__);

[Severity: Medium]
Since this is on the hot I/O path for every upcall, could an
unprivileged user trivially flood the kernel log by reading a mapped
file with ext_offset set to 0? Should this use a ratelimited printk?

> +
> +		/* local_offset is the offset minus the size of extents skipped
> +		 * so far; If local_offset < dax_ext_len, the data of interest
> +		 * starts in this extent
> +		 */
> +		if (local_offset < dax_ext_len) {
> +			loff_t ext_len_remainder =3D dax_ext_len - local_offset;
> +			struct dax_device *daxdev;
> +
> +			daxdev =3D famfs_daxdev_from_index(fsi,
> +						meta->se[i].dev_index, &rc);
> +			if (!daxdev) {
> +				meta->error =3D true;

[Severity: High]
If reading a file races with famfs_daxdev_open(), could failing to find
the daxdev prematurely latch meta->error =3D true? Since this flag is
persistent, does this permanently deny access to the file? Also, is it
safe to write to meta->error locklessly from concurrent fault paths?

Additionally, if famfs_daxdev_from_index() returns NULL with rc =3D 0 due
to reordering (as asked earlier), does this return 0 to the VFS while
leaving iomap->length uninitialized, causing iterators to malfunction?

> +				return rc;
> +			}
[ ... ]
> +			iomap->addr    =3D dax_ext_offset + local_offset;
> +			iomap->offset  =3D file_offset;
> +			iomap->length  =3D min_t(loff_t, len, ext_len_remainder);

[Severity: High]
Similar to the interleaved case, if dax_ext_len is extremely large,
could it cast to a negative loff_t, resulting in a negative
ext_len_remainder and causing iomap->length to become negative?

> +			iomap->dax_dev =3D daxdev;
> +			iomap->type    =3D IOMAP_MAPPED;
> +
> +			return 0;
> +		}
[ ... ]
> @@ -412,7 +711,7 @@ __famfs_filemap_fault(
>  		file_update_time(vmf->vma->vm_file);
>  	}
> =20
> -	ret =3D dax_iomap_fault(vmf, order, &pfn, NULL, NULL /*&famfs_iomap_ops=
 */);
> +	ret =3D dax_iomap_fault(vmf, order, &pfn, NULL, &famfs_iomap_ops);

[Severity: High]
Looking at __famfs_filemap_fault(), it locklessly checks IS_DAX(inode).
Since famfs_file_init_dax() sets inode->i_private, updates i_size, and
sets S_DAX without memory barriers:

famfs_file_init_dax() {
    inode->i_private =3D meta;
    i_size_write(inode, meta->file_size);
    inode->i_flags |=3D S_DAX;
}

Could the page fault path observe IS_DAX being true, but read a stale
i_size of 0? If so, would famfs_file_invalid() incorrectly latch
meta->error =3D true because i_size !=3D meta->file_size?

>  	if (ret & VM_FAULT_NEEDDSYNC)
>  		ret =3D dax_finish_sync_fault(vmf, order, pfn);
> =20
> @@ -534,7 +833,7 @@ famfs_dax_read_iter(struct kiocb *iocb, struct iov_it=
er	*to)
>  		return rc;
>  	}
> =20
> -	rc =3D dax_iomap_rw(iocb, to, NULL /*&famfs_iomap_ops */);
> +	rc =3D dax_iomap_rw(iocb, to, &famfs_iomap_ops);
>  	inode_unlock_shared(inode);
> =20
>  	if (rc > 0)

[Severity: High]
This isn't a bug introduced by this patch, but by replacing the NULL ops
with &famfs_iomap_ops, does dax_iomap_rw() now succeed and inherently
update iocb->ki_pos? If so, does the subsequent manual advance of
iocb->ki_pos via iocb->ki_pos +=3D rc (just below this diff) cause a
double-advance of the file offset during sequential reads?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/010001a04e801a4e-8e=
b212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com?part=3D8
