Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63A33D9DDC
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782314049; cv=none; b=J93lhuYfPCkacVb0HJ47GVxiinBBg7DWbVbtOE3GDT5WxS+AzOZE1mctK1VhHZbEASdxJmdbOVeb93wxxhLuAfMREl8ZKZUf+bXfLFIHrUNNzFdLeVSEazY3P2mjOjeN7gtSW49r0WFSLjwZTvcTCZps0fpw57oeCJTOL/xsX20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782314049; c=relaxed/simple;
	bh=97/qbvVTs/jF8SZ4AfcqRjJ7YmwC+4lUHCDgaKzf6Do=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ltDHV+NCDO6P/f0WvUl9YunmtJhsgORL0adFAPhNzoRMwQdzR82ViL7QmorQUnZ0LhoOxmelSzfMBbV27OL+CKDocC10Jc1A/vbEtz18zRNJH3VvA+52q7jt2xAPbWKfLgd0V571UDBhDYTHaPol1M1RGrzi9oYEYHr/xAaiyg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CXInSR0Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CXInSR0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B19C1F000E9;
	Wed, 24 Jun 2026 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782314048;
	bh=LEf9GRjVl29E7vbdSKRWdyU5bkqg+GNP4JsLuRfBZ+w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CXInSR0QhOH03LPrwcOSP5x+CLFzTuUeBzZRWR0y/AsOnTMfrBj/W8+QHVo64h/fO
	 linLRjLCO2gvKpGiHRuwLa5iYyO2i93Pg7ApsQC5fLiQvMmclPZISZXG2BDtvc0yT/
	 xG9YOrh/XxGA/6z/XEQvB6ea7TrjFNRGGFoUtM23d5gfKHtAyxgRnbC4MdbzUlvm8H
	 hdAX/+P95gHhgATpHeK13oYUdf280sH+dWdHwdM0hWCbWYfxnBQlzy3xbM7rCokcmx
	 j7f+zVs9JRBkfW8CnphYUvSmQiZCDud2dyQG5QJdKCQ4fMcNE4GAEnrZ9sxmWbYpZD
	 DUvDZPo51yx4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] nvdimm/btt: fix sequence endian in btt_log_read
 error print
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ben Dooks" <ben.dooks@codethink.co.uk>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260624150602.905561-1-ben.dooks@codethink.co.uk>
References: <20260624150602.905561-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:14:07 +0000
Message-Id: <20260624151408.5B19C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] The patch open-codes the endianness conversion of the log sequence =
numbers instead of utilizing the existing helper function `log_seq()`.
- [Low] There are multiple spelling errors in the commit message.
--

commit 41767fa21db59b2ed77d8052ff41a18c93ebf763
Author: Ben Dooks <ben.dooks@codethink.co.uk>

nvdimm/btt: fix sequence endian in btt_log_read error print

This commit fixes endianness warnings in btt_log_read() by converting the
log sequence numbers to CPU endianness before printing them. It ensures the
correct sequence number is displayed and resolves sparse warnings.

>     The error reporting in btt_log_read() prints sequence numbers out
>     from the log which are stored in little endian without any endian
>     conversion. Make sure these are passed throuhg endian convesion

[Severity: Low]
This isn't a bug, but there are typos ("throuhg" and "convesion") in the
commit message.

> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -341,8 +341,9 @@ static int btt_log_read(struct arena_info *arena, u32=
 lane,
>  	if (old_ent < 0 || old_ent > 1) {
>  		dev_err(to_dev(arena),
>  				"log corruption (%d): lane %d seq [%d, %d]\n",
> -				old_ent, lane, log.ent[arena->log_index[0]].seq,
> -				log.ent[arena->log_index[1]].seq);
> +				old_ent, lane,
> +				le32_to_cpu(log.ent[arena->log_index[0]].seq),
> +				le32_to_cpu(log.ent[arena->log_index[1]].seq));

[Severity: Low]
Would it be better to use the existing log_seq() helper function here
instead of open-coding the le32_to_cpu() conversion?

For example:
    log_seq(&log, arena->log_index[0]),
    log_seq(&log, arena->log_index[1]));

>  		/* TODO set error state? */
>  		return -EIO;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624150602.9055=
61-1-ben.dooks@codethink.co.uk?part=3D1
