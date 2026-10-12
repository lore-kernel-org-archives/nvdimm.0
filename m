Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BB14AF679;
	Mon, 12 Oct 2026 16:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791823133; cv=none; b=CB9Z4lU5o2gksACyFk16/XkiqDnP0v8LngznHOmuaYaX4uXf7CT0B3C0OWbXaa2ysDVIYguya7/bAFyKXdA4uIuRnI7YCqTogBruiqLcCoWdMwXBUbqR18KxHM6RseDdvjM6moergT3GHITptKrrNrzUIRviMOm6X8ImmSfsYfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791823133; c=relaxed/simple;
	bh=/mK22dta9kNjF7ZjGNr1WtxNtqsskF5mTL23V9gBXZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kodSCRlr2X30EfEH9rbwG3EPVBhrsUGqer9QNP/vhYp5mrgYzHe7BTM4VqcYYiWZhfhlTrSHZNHKzVGO4qUDzDa/3WgO1Pd05hXLeqlpfPhCc7Mw+Yzfmw0JGtjMr6PCxuEdFHnbERbfHk9MxX6N68fxfvPIMXN0FyneZKI/RBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PoS36Qib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PoS36Qib"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 71F8B1F0089C;
	Mon, 12 Oct 2026 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791823131;
	bh=szjcYq+EbhVJ+5lSDxxeRT3bShaf2kRoD2IGWvKJDPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PoS36QibNCy6wANR4L2Qf2luYhUeNCU4kDGruG3kYtyyr9MOXSZtaicKoRM7iyNP1
	 kBL9ogfYAkquYe2gxoqoR5zp1rEbWm6K/MtWuY2JqFo/RXW7anLYQCRhcf6IsizknP
	 WRyyeyPCxgZTEtFPjdNCfbgDkTuMrJGvQIuhYgwbSDl8CS1TWbZyHZMEZ1/GCHckUd
	 fTsXc/TDd2SCdHKl3By/bzo1wLeOIXwJT9LZU1Z9EELbZWCOy9Fi4V0XTLdyq629uS
	 5OEer7+CPB+uVaB5xYc8t7lEQNNz+zFN68PN3hp6AY1U5Wd8ajLVGqUWeAOenRTqEE
	 eG40W0QZWiQxQ==
Date: Mon, 12 Oct 2026 09:38:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: jianyungao89@gmail.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <linux-fsdevel@vger.kernel.org>,
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v2] dax: fix wrong error code returned from
 dax_dedupe_file_range_compare()
Message-ID: <20261012163851.GU1615495@frogsfrogsfrogs>
References: <20261012144925.6728-1-jianyungao89@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012144925.6728-1-jianyungao89@gmail.com>

On Mon, Oct 12, 2026 at 10:49:24PM +0800, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> When dax_range_compare_iter() returns a negative error code (e.g. -EIO),
> dax_dedupe_file_range_compare() incorrectly returns 'ret' which holds the
> positive return value from iomap_iter() indicating more iterations remain.
> This positive value leaks to the caller, where vfs_dedupe_file_range()
> interprets it as success (bytes_deduped = len), causing userspace to
> incorrectly believe deduplication completed.
> 
> Return 'status' instead to propagate the actual error code.
> 
> Fixes: 39eb05112987 ("dax: advance the iomap_iter on dedupe range")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Seems fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> 
> Changes in v2:
> - Add Fixes tag and Cc stable
> - Add Reviewed-by tag from Jan Kara
> 
> v1: Link: https://lore.kernel.org/lkml/20261010021010.19575-1-jianyungao89@gmail.com/
> 
>  fs/dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6ba50142eeb2..1f6a4fbb97bd 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -2261,7 +2261,7 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  		status = dax_range_compare_iter(&src_iter, &dst_iter,
>  				min(src_iter.len, dst_iter.len), same);
>  		if (status < 0)
> -			return ret;
> +			return status;
>  		src_iter.status = dst_iter.status = status;
>  	}
>  	return ret;
> -- 
> 2.34.1
> 
