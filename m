Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1A63246E3
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 05:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769061600; cv=none; b=CfKxXSdzQyj+GG7Bxv+j4KQBVxOoOhXwBlpjBtmKLlsjR2wSTD8sLJQuqZ6rZnODJEk3UqZHIqWq14JsePfRDjFmS8q1P99P42Q2ArdNRoy0l6GH/EEXxUwLkFrq5cKgDEhq0PuBoFKqiveunMb09mg6g/s95pn7SEDh8GujgC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769061600; c=relaxed/simple;
	bh=AUM4cTsAHo2KpfyeYkwusVbFC2K/h4rgaNm312fW9tc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZqv9T9ajOIvEIYKMl0Y7upqR3XiFpOpeCiYWiLfUgl9ocj0vj7bldxMt51Z8ZCRIvRi/6yyL66WGdwt7O/kUPj7spm+U8Tqk3J0l3ZyGWD6qwnSaGa28BlQlkBwD2btKkc8vWqKr+xDR+jfYuXL4WuV6NXA1+PQUo0l/MtcfsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E5719227AA8; Thu, 22 Jan 2026 06:59:56 +0100 (CET)
Date: Thu, 22 Jan 2026 06:59:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/15] iomap: only call into ->submit_read when there
 is a read_ctx
Message-ID: <20260122055956.GA24006@lst.de>
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-11-hch@lst.de> <20260122004451.GN5945@frogsfrogsfrogs> <CAJnrk1YAbcODi8pkG9XawciDpaHqdbZE+ucji73D_F=Jv1kQXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1YAbcODi8pkG9XawciDpaHqdbZE+ucji73D_F=Jv1kQXg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 21, 2026 at 06:44:12PM -0800, Joanne Koong wrote:
> On Wed, Jan 21, 2026 at 4:44 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Wed, Jan 21, 2026 at 07:43:18AM +0100, Christoph Hellwig wrote:
> > > Move the NULL check into the callers to simplify the callees.  Not sure
> > > how fuse worked before, given that it was missing the NULL check.
> 
> In fuse, ctx->read_ctx is always valid. It gets initialized to point
> to a local struct before it calls into
> iomap_read_folio()/iomap_readahead()

Ok, thanks.

