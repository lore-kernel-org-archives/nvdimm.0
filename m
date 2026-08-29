Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F569415F2B;
	Sat, 29 Aug 2026 17:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788024423; cv=none; b=pC3CxzXiDBTSy2juX7/y13OLXayr5SwBOqb38RZq+6D1mHQuULw5xEu9EH/kRpq5NnutHjfBUQgBsEH/SVQz3cgQ0xkoiCCTNBee/rApK9tuhoX+fP7R7ipz6XR8IqMlGPB2Qov/GckIbo327jDAmsFvdF1tScLRJeQ2Bm+te4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788024423; c=relaxed/simple;
	bh=xDVOOLbdojfZB/0SyR9UICap0s+KBhsZw8ZYJgLXOuE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ITLRcfRpLPYLIHMGzoCi2Y2AJCaZnNPJ9aGMpPrvLuJp7oh5ibpGt3FkhqOlujfPrpi5cRuuW9+RKpnr4hAcHMRxfVwRiHWqqlIZkCznSoAQYOkgF3vse9DMQWCYhiAhEzQyfLIeq3VjkEAVOf8n8O1DqKzgnOTld14pBBXvDpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fpfIFWpo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fpfIFWpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E8E1F000E9;
	Sat, 29 Aug 2026 17:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788024420;
	bh=0TIBqLVXLKtossgdCaTeYxi9yesYTp+xHIIdf/Om5WY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fpfIFWpoioIGK/VqAmhMzRo9Eo1G5yyyx3VEWTsk+dCgrK+BYGJ7BqbxTQXu/vX2y
	 KrexwZ10DjKzp/cmihWYOGwrPWWjFRWoRe3f3lLA8S8UzU0JHHqSbrJfHb2k5A8VFa
	 C/OKiiyY2gAHFb/UwdijyoF/nf6BQxq8nzWHMDmmq3UWWaOzURZs/u6D6OjETVBiaA
	 vmoBhme5/A4LpQAT5KyoDd+abJTq7mMSmTZUzWBiER/gJsVSPbDXO6bBCv0BuU/HtC
	 wrRx8NlUJZSfgIqyXzSG247IqF8AbSNy2mSiNbXLWm2HuxTpy/PPDM5BIc073zRLzV
	 C6drDJn3P56tA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V14 06/12] famfs: Introduce mmap and VM fault handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <010001a04e81858b-7fcc80df-8aa2-4262-9727-8cb01a0227fb-000000@email.amazonses.com>
References: <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
 <20260829171139.7439-1-john@jagalactic.com>
 <010001a04e81858b-7fcc80df-8aa2-4262-9727-8cb01a0227fb-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 17:26:59 +0000
Message-Id: <20260829172700.41E8E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Modifying VMA flags in a legacy .mmap callback breaks VMA mergin=
g, leading to memory fragmentation.
--

commit f0dd25d565afad641be49c7b1903722fa578648a
Author: John Groves <john@groves.net>

    famfs: Introduce mmap and VM fault handling

    This commit adds vm_operations, plus famfs_mmap() and fault handlers.
    It is still missing iomap_ops, iomap mapping resolution, and
    famfs_ioctl() for setting up file-to-memory mappings.

> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index 1369fe1824bc8..9c1cd2f674893 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
[ ... ]
> @@ -120,14 +190,51 @@ famfs_dax_write_iter(struct kiocb *iocb, struct iov=
_iter *from)
>  	return rc;
>  }
> =20
> +static int
> +famfs_file_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct inode *inode =3D file_inode(file);
> +	struct super_block *sb =3D inode->i_sb;
> +	struct famfs_fs_info *fsi =3D sb->s_fs_info;
> +	ssize_t rc;
> +
> +	if (fsi->deverror)
> +		return -ENODEV;
> +
> +	/*
> +	 * Gate shared-writable mappings on FAMFS_OPT_WRITE. Reject a mapping
> +	 * that is already writable, and strip VM_MAYWRITE from a read-only
> +	 * shared mapping so a later mprotect(PROT_WRITE) cannot upgrade it.
> +	 * This is best effort: it does not revoke mappings that already exist.
> +	 */
> +	if ((vma->vm_flags & VM_SHARED) &&
> +	    !famfs_opt_enabled(fsi, FAMFS_OPT_WRITE)) {
> +		if (vma->vm_flags & VM_WRITE)
> +			return -EPERM;
> +		vm_flags_clear(vma, VM_MAYWRITE);

[Severity: Medium]
Does clearing VM_MAYWRITE in the legacy f_op->mmap callback break VMA
merging?

Since this occurs post-merge attempt, these modified flags diverge from the
initially proposed flags. Subsequent adjacent mmaps of the same file with
identical protection will fail to merge.

Should this driver implement f_op->mmap_prepare() instead to modify VMA
flags before the merge attempt?

> +	}
> +
> +	rc =3D famfs_file_invalid(inode);
> +	if (rc)
> +		return (int)rc;
> +
> +	file_accessed(file);
> +	vma->vm_ops =3D &famfs_file_vm_ops;
> +	vm_flags_set(vma, VM_HUGEPAGE);

[Severity: Medium]
Will setting VM_HUGEPAGE here guarantee that adjacent default mappings fail
to merge?

Like VM_MAYWRITE, modifying this flag post-merge attempt prevents the core =
MM
subsystem from successfully merging new mappings with existing ones.

Should VM_HUGEPAGE also be set via f_op->mmap_prepare() instead?

> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/010001a04e801a4e-8e=
b212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com?part=3D6
