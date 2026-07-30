Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5A33AB273;
	Thu, 30 Jul 2026 17:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785433088; cv=none; b=YY0GnxbF+Y7oVUAxMIDbhF3low+wGVRCVQEq/C0WBhwXIYpjepQ8UgSeNGYaDgGXBof2aJu0XmqIf9CCx5LMcffEduVHLXIUjUraB9aG/Cx451fPPlbr7Nm7T40BxqeNVl+IhNnHSVvwZtWT+8FkpYBwaGEyQemAwYpswNMditU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785433088; c=relaxed/simple;
	bh=9yTSYITKRyfSgAMT4KNqXonaMfmcOC6oJ44wCxs21tk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=O/1XUsX9nWrrA5p8B3s8H1fXcFqWkbsjL7RnpRkEItxXTI7gjMh62X9xTIdW4mbZG2itjhqTyhEE4na/01ct3WUED+Rwfx0OOETkvHc/4wDkeRrVxjXPmUEwsVpx7jdlk+5TiJ1hV1XLmm27XrDppBsl/pH17Klx2Lkf/D1PvI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ck/rHuwC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ck/rHuwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A431F000E9;
	Thu, 30 Jul 2026 17:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785433085;
	bh=Ni3oFAKFSnWXIfFUyIufn9NPE6DB7h3R++xJCPyWKBU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Ck/rHuwClLfG9ICgb/oWs/GPP+TzALltZy3TrlWrjFNP32MYVLDvNsWdEOIg9mwA2
	 kCiOGJAkwf4GAeu7rWuGnd9gaTQSHKpf7h1q1bzOwT3lDNxwzadxKfF6f3+dE7B3mr
	 /+KLiw/7l1AGFX56+oH62A/kjmEhwITeSSyb4Wco=
Date: Thu, 30 Jul 2026 10:38:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Seunguk Shin <seunguk.shin@arm.com>
Cc: <linux-kernel@vger.kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Matthew
 Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <Nick.Connolly@arm.com>, <ffidencio@nvidia.com>
Subject: Re: [PATCH v4, RESEND] fs/dax: check zero or empty entry before
 converting xarray entry
Message-Id: <20260730103804.063ce671588b02c2596d5de3@linux-foundation.org>
In-Reply-To: <m2v79wmxig.fsf@arm.com>
References: <m2v79wmxig.fsf@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Jul 2026 14:12:55 +0100 Seunguk Shin <seunguk.shin@arm.com> wrote:

> dax_associate_entry(), dax_disassociate_entry(), and dax_busy_page()
> call dax_to_folio(entry) before checking whether entry is a zero or
> empty xarray entry.
> 
> That ordering is wrong because zero and empty entries are not folio
> entries. Commit 98c183a4fccf ("fs/dax: don't disassociate zero page
> entries") added guards in the associate and disassociate paths, but the
> guards still come after dax_to_folio(entry), and dax_busy_page() still
> has the same problem.

Are there any known userspace-visible runtime effects of this?

If so, please fully describe them in the changelog.  If not, please
also mention that.

This is important information for deciding which kernel(s) need the
patch.

> Move the zero/empty checks before dax_to_folio(entry) in all three helpers.

Thanks.
