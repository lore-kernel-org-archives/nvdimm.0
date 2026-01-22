Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5AB2777E0;
	Thu, 22 Jan 2026 18:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769104979; cv=none; b=DM5K5MeWNBbn8baz/erAqFnVn7o55IchCglLJIiHkSXxud+KS0l9rB52bNvvDJxBOuiuBNu+nOW3jKPtYKa+I5BpNWN1rhQaIFnRdosFYq3PpnY+XFTojNQ1teU+8Z5DlcPKt4EsjlFNsqDM36xhA9OH9bi3Wv9k5j4Pz/Ml0RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769104979; c=relaxed/simple;
	bh=gjKicgNqMqK0K6Xv0UsB5J34SJLW92JZXavI/zP8qD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TlOXKrGSrdK6V8Bkx6/7iMWn9KDgOruxA+fiUeDe+Z6urPLqHwLUpiow+pnqnPWGq0JZasUjESkInxUpSt1q9SmxLtojx4/DRAHNiIsCEr3RMTfGTFO+gkhWuvRGvNZto3m8YINmc9i8GoHPQeXqP07lPhdv+uO8OCIHnap2vEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tfMEETm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tfMEETm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F0AC116C6;
	Thu, 22 Jan 2026 18:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769104979;
	bh=gjKicgNqMqK0K6Xv0UsB5J34SJLW92JZXavI/zP8qD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tfMEETm7CvPSBpRdlEL9YLDy5FwijI69KZZT6Pgb86kxg8tkm7i2NrUGgWI7rTnf6
	 oJEd9a6gI/pe3CvfSRkCBgTyhRL5LCL2Vv5nHaTij7HczMjVFoKEwPBk5vDM3puA9i
	 7li7ciJK5RtVhrgW3w5KslM5zf/qqlje0hxnCvBCynWF06Bq/+h32JjppdHovYVqUu
	 XLIA1uyhGfbtPKWFiLLSJ8loRZqYipEo8v5hL5vcw7iPEBNYpc2vSDNNrGRorQKW6+
	 WgYMmA/9hHrly5tOnR5FXRXGw/bYYoJNsE6423Pv2KEsyEi12Kd/voR7oOd4Dsd2J/
	 zkp4NECfbsB1w==
Date: Thu, 22 Jan 2026 10:02:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Joanne Koong <joannelkoong@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/15] iomap: only call into ->submit_read when there is
 a read_ctx
Message-ID: <20260122180258.GB5945@frogsfrogsfrogs>
References: <20260121064339.206019-1-hch@lst.de>
 <20260121064339.206019-11-hch@lst.de>
 <20260122004451.GN5945@frogsfrogsfrogs>
 <CAJnrk1YAbcODi8pkG9XawciDpaHqdbZE+ucji73D_F=Jv1kQXg@mail.gmail.com>
 <20260122055956.GA24006@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260122055956.GA24006@lst.de>

On Thu, Jan 22, 2026 at 06:59:56AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 21, 2026 at 06:44:12PM -0800, Joanne Koong wrote:
> > On Wed, Jan 21, 2026 at 4:44 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Wed, Jan 21, 2026 at 07:43:18AM +0100, Christoph Hellwig wrote:
> > > > Move the NULL check into the callers to simplify the callees.  Not sure
> > > > how fuse worked before, given that it was missing the NULL check.
> > 
> > In fuse, ctx->read_ctx is always valid. It gets initialized to point
> > to a local struct before it calls into
> > iomap_read_folio()/iomap_readahead()
> 
> Ok, thanks.

Looks good to me then,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

