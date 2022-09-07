Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268E32F42
	for <nvdimm@lists.linux.dev>; Wed,  7 Sep 2022 19:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=+DO9PJ9PCaNVPZYQL7TZNd3HsSVUQ8mCFOzsLfBNxVE=; b=Ebb0M5q6tGt+wCnW3zhKTLH1SV
	Yr0uhQaU8bjxVIXLMikL83acJ9ze5VDYKFryUm3eI0ADUPO69qYGhTlzgMRgjs/TGev7VqtpTrPL3
	GtPpLhd15iqN0H/GobLc9loKxjQhgeu0K/DuuJgDjAPOua+8hKOip2rKVI+4kUquFFCucfOBS99XP
	P1IreUaIIA85RG2c2g625/4dIDnfEfnIMgzMYNlf0dC8tmM/vqtWsZxE78gSqIxh1Neab86HYp8R7
	fQOs86cbih699OBhLYTD5iMqrOHuJyd4sNBvpfuIEESGxvQy+8esepx8fFVSAUpY9Lkt2EmXS731L
	bpD7DXdA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oW0rB-00958O-Ay; Wed, 07 Sep 2022 19:37:05 +0000
Date: Wed, 7 Sep 2022 12:37:05 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] meson.build: be specific for library path
Message-ID: <Yxjy4S7kP1m4HJUN@bombadil.infradead.org>
References: <Yv2UeCIcA00lJC5j@bombadil.infradead.org>
 <d6139a6017284995cf1132934d3b61a47804d88d.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6139a6017284995cf1132934d3b61a47804d88d.camel@intel.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Aug 19, 2022 at 06:26:46AM +0000, Verma, Vishal L wrote:
> On Wed, 2022-08-17 at 18:23 -0700, Luis Chamberlain wrote:
> > If you run the typical configure script on a typical linux software
> > project say with ./configure --prefix=/usr/ then the libdir defaults
> > to /usr/lib/ however this is not true with meson.
> > 
> > With meson the current libdir path follows the one set by the prefix,
> > and so with the current setup with prefix forced by default to /usr/
> > we end up with libdir set to /usr/ as well and so libraries built
> > and installed also placed into /usr/ as well, not /usr/lib/ as we
> > would typically expect.
> > 
> > So you if you use today's defaults you end up with the libraries
> > placed
> > into /usr/ and then a simple error such as:
> > 
> > cxl: error while loading shared libraries: libcxl.so.1: cannot open
> > shared object file: No such file or directory
> > 
> > Folks may have overlooked this as their old library is still usable.
> > 
> > Fix this by forcing the default library path to /usr/lib, and so
> > requiring users to set both prefix and libdir if they want to
> > customize both.
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  meson.build | 1 +
> >  1 file changed, 1 insertion(+)
> 
> Hi Luis,
> 
> This sounds reasonable, but I've not observed the behavior you
> described unless I'm missing something in my quick test.
> 
> Both before and after this patch, the default path for the library for
> me was /usr/lib64. This is on Fedora 36 with meson 0.62.2.

FWIW, my results was with debian testing. I see this is now merged, great,
thanks.

  Luis
