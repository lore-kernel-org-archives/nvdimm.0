Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F2A4F053F
	for <nvdimm@lists.linux.dev>; Wed, 30 Sep 2026 14:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.235
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778596; cv=pass; b=Rgnh/nHBGGhQ6E3L3NHQCMNolE90kxxE2rxoUgJutBW/1DkxMsDgDdQ6+37OvCuq/8W6fdohY3zwThJnnvy0CbCGZJYYsZPP5fILFU9gpTrl1fEpOIgGiyUiWGi2DSHPpeFDXJ02Du/jQbnZxUrDTobx7UM6q5sATByCSh7tVHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778596; c=relaxed/simple;
	bh=Jv5f1g0f3qDS45IX1yQFN/XI/1HiyQaIpDbEOG1DCc4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=WzLTfuNJUMIxW1GT1HK9dlLRSbj2E8BBvGI0Z7YaTLxq6mvui/bAFYCW0StZc1Kgq7tEBwEgbuqgbLGAYRJfNR8yrFlj0SXn6Nl8iPOknRgEDH2+1tCw0kOEG7k8ZyDG/bP3XGHnzl1ivqRXMf48gWd6I0ghr4dB0BClyoZ6Go8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=alFWgbX7; arc=pass smtp.client-ip=74.125.230.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="alFWgbX7"
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-532db7db0c6so50023301cf.2
        for <nvdimm@lists.linux.dev>; Wed, 30 Sep 2026 07:29:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790778585; cv=none;
        d=google.com; s=arc-20260327;
        b=TQKKmuVKZECQVTl42qiPcv0ghggkULaMwjZX3UXLf7nQZe7YPXfoxxuLKpRvnR4kq9
         p41QdKXw70pgrSSCnFgXSH0lKkly2/20lIRX310DgqgWg3of0HTVgFU8REIisbauDtkz
         mb/LBDj8GmJmmZvzlkAN4N0EPFDQxV51VV035EayMzYfQ9CNhJ+h+7stVN1EbONu7Ani
         MsuKPPeliL8J/6RaPPeZZoAKe29CuZXpESHbPj10l6GEkIuSlCZ3xY+iaWCFFN0Amu1O
         Gpn5BpPDlxDeZC8r6Pck9tq3oqbOYy9TZyR1Lg9JgddjebW2AnRpK9t7xQwWcB0EHtZm
         im1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=bFcOr5qvsPCgBjFZ4BWLUmj9QlCgJD693TK70ZfQ/Lc=;
        fh=LTokBv8r0jizl0e5qQkVC+16W2NyvFRLmXc8GoWDjOw=;
        b=ixSpvpEkt7uYuJPoHkI8AriRg5QbSj9SgIRcJe3KEi3XraardieuqSZA3YJRX9Os/v
         X7KDzhO9BeSYpVOhiAV1w5yEaVVP2NKzCUFR++Zz3ZyJlPsMuAbqEo6ekRzZUZU/pJEP
         fxc5wIU8sWQzOGE5oj8Ju1CS+1EfjoqxlzJidOwTlJi31aPouRBgXg1uLBb4NhaBogGm
         dwDlmFsDaENKUsZgT3/GHF4b5EwOlcpMY8epNAhi2HrS6Jva/vkmxkLevdHP0j9znfxj
         jqQFFKkTutN4x6dUC0vuaFZhpKVFxwO1Fmyojj18dYD+lFrV5V8I98HIAtz51GjExE5V
         xXyQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1790778585; x=1791383385; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bFcOr5qvsPCgBjFZ4BWLUmj9QlCgJD693TK70ZfQ/Lc=;
        b=alFWgbX7pccMXsmZjsw5DXuqREEPQaa+uIwTxCwzn8WKIAF8uTm0EMXtYKStmIvMkB
         Y3xexy/O6iks1IMDNwNFx7mJMShEBw1dO+tK2lrUwD8ruGMPF69ruZpmAoxoR/N8IzXi
         eSug9pYhQjWQEeX7H0Nl5m4gQN7XmbtHrooTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790778585; x=1791383385;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bFcOr5qvsPCgBjFZ4BWLUmj9QlCgJD693TK70ZfQ/Lc=;
        b=HoTf9ka+sd0B7WN/PEl5h7vnKWR/87ya3h5Wq0fAOjTxu/EhnEegWSc+KmG1xrsb3C
         VXF7mzDcfC0INXBdJ+HLr5S57mP/qCdZl5FzxaXGhPPwG0Qfyyt7Ow6xBiZ67p55kh5A
         NOHb0aPZzjRPYfBkcIa4vMZU7ti9f5ifaN0kCTtV6fFai2JyTucKlo9lsw3bwh5IJkEL
         69ssxUGkawZ/CFrDQy2F08cuPsEphXEHUsiBUsawaFbLv2poH/aIhFnMHr1KPQfNC8ze
         Hm5FxC3G3fnqZwpuEZKzd5Uwwui9+zhL1tmNXR6B7o6J2w8dg0JQmU+qHfF0o1D5rPGV
         6IHw==
X-Forwarded-Encrypted: i=1; AKwUvBzFgWnZIP0MxLWDowdPfrNBPWcQqrhmRk+w0jLAOGOOjlewWjUI+FMFYwD/80OgXRhs+DX5RgI=@lists.linux.dev
X-Gm-Message-State: AFuF++lHYbaPOZlKkjiZYRTARci78Ie2O4XW8EPx6NCtpddrBDNMXI4w
	UcDLMzVwc0ko80yiuLzfenAYltXgSLeZmhQwOymi+NUJUsN4KzjOOtWQ3s8Zx5hp0BLKKPuufnD
	oGXkWLD59MlB/MnAO2EjbWMDaklsmpxPTOup1M8a5HA==
X-Gm-Gg: AYBFou29xvwXbouVFo2WqFpGUZX5oq9kHnwqgLOdjIUSYf64dy17p/WJaqmECRth85X
	SDE4l+5pCbmTm7eMF2TJuRU4PbNESUM2fuU5pWhf44WLDxzsMm3lkHYKiC/dBETgQGyzQQ8p7wt
	Fyrl6y7mGQM7Qbyq6cHLS4kvYeIADGMQ2ms+E7gseAEYPIiAR8P744i7f0ohp/gqiYcCH6DOLIr
	NjzhfgAF29IO6LZCWx1NKNSo/0HSKarckKi1XxOcKmr7Bti5E7GkkKk/M5FaOpUuhGnz5S0deLj
	NmMUd0QwTF0jTJl35MdQYg1bpWrAKr5pqchLtLn38orUoUSNr2zIcbh7rzIzf+PWSkSbYaP2YMA
	YSrpqgF2jeRTh+Q==
X-Received: by 2002:a05:622a:258f:b0:533:32f3:1db0 with SMTP id
 d75a77b69052e-533742bb8cbmr29673951cf.6.1790778584578; Wed, 30 Sep 2026
 07:29:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Sep 2026 16:29:33 +0200
X-Gm-Features: AclHuK8GeOe_W3mvOTyMrVDZeZ25RiRcVppHiB0syijS4_yNrxLEymVmpXQKS-M
Message-ID: <CAJfpeguyOXGQO4Q8rSAc8GxExTJU0G2o19fxRnh_93GvAoNcRg@mail.gmail.com>
Subject: fs_put_dax() vs. dax_holder_notify_failure() race
To: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Cc: fuse-devel <fuse-devel@lists.linux.dev>, Carlos Maiolino <cem@kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org, 
	John Groves <John@groves.net>
Content-Type: text/plain; charset="UTF-8"

During ->notify_failure() callback will dereference holder.  It may be
NULL at this point, resulting in an Oops, or it may be non-NULL but be
freed during that call, resulting in UAF.

This affects xfs at this point, but the fuse extent map patchset[1]
also adds dax failure handling and is affected by this issue.

I think this should be fixed in drivers/dax/super.c, since this will
be a problem in each user.

Thanks,
Miklos

[1] Report from sashiko (select Patch 8):

https://sashiko.dev/#/patchset/20260922061019.3320196-1-mszeredi%40redhat.com

Or here it is inline:

commit 1580a2f8ad3f103a20b6280aa39a01f8b0be2d3f
Author: Miklos Szeredi <mszeredi@redhat.com>

fuse: add support for opening dax device as backing

Add FUSE_BACKING_IS_DEV flag that allows opening a character device
(dax device) as a backing, in addition to regular files. Mark the
inode with S_DAX if FUSE_LOOKUP returns with FUSE_ATTR_DAX set.

> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 58dbdd17c1ef4..aa558a0c2e647 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
[ ... ]
> @@ -22,9 +23,16 @@ static void fuse_backing_free(struct fuse_backing *fb)
>  {
>   pr_debug("%s: fb=0x%p\n", __func__, fb);
>
> - if (fb->file)
> - fput(fb->file);
> - put_cred(fb->cred);
> + switch (fb->type) {
> + case FUSE_BACKING_PATH:
> + path_put(&fb->path);
> + put_cred(fb->cred);
> + break;
> +
> + case FUSE_BACKING_DAXDEV:
> + fs_put_dax(fb->dax_dev, fb);
> + break;
> + }
>   kfree_rcu(fb, rcu);

Does this code introduce a use-after-free race with a concurrent hardware
memory failure?

When a DAX-backed FUSE backing file is closed, fuse_backing_free() drops the
DAX device holder by calling fs_put_dax() and frees the backing object using
normal RCU via kfree_rcu().

Concurrently, a hardware memory failure can trigger dax_holder_notify_failure(),
which protects its read-side critical section with SRCU using dax_read_lock().

If dax_holder_notify_failure() reads dax_dev->holder_ops and checks for NULL,
and is preempted here, fs_put_dax() can run to completion. This would set
dax_dev->holder_ops and dax_dev->holder_data to NULL, and eventually free fb
after a normal RCU grace period.

Because kfree_rcu() does not wait for SRCU readers, the memory could be freed
while dax_holder_notify_failure() is still running.

[ ... ]
> @@ -79,23 +87,88 @@ static struct fuse_backing *fuse_backing_id_remove(struct fuse_conn *fc, u64 id,
>   return fb;
>  }
>
> +static int fuse_dax_notify_failure(struct dax_device *daxdev, u64 offset, u64 len, int mf_flags)
> +{
> + struct fuse_backing *fb = dax_holder(daxdev);
> +
> + fb->dax_error = true;

Can this code cause a NULL pointer dereference or use-after-free when racing
with fuse_backing_free()?

When dax_holder_notify_failure() resumes after the race described in
fuse_backing_free(), it blindly calls ops->notify_failure() which is this
function.

Because fs_put_dax() may have already cleared dax_dev->holder_data,
dax_holder() might return NULL causing a NULL pointer dereference here.
Depending on the timing, it could also return a stale pointer to the freed
fb object, resulting in a use-after-free.

> +
> + return 0;
> +}
