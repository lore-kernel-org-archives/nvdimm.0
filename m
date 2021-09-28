Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D40A72
	for <nvdimm@lists.linux.dev>; Tue, 28 Sep 2021 05:16:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1B4E61153;
	Tue, 28 Sep 2021 05:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1632806170;
	bh=WmxPPV62KaG2zFfOZV1wHgC3rJsSCIy35+4cNxHrtXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ioo5noKryLD7apNBqMA6BJJ5GbV5Y7AirwSLR13zpfKEqI4/2bOSpQ9tAHNRFiKxm
	 GXGkI4frJm3sq3KnUjdRE4zJBjVDTtvG4nrzWN7Te58KvnrT5/3gqzeAtsKHHVF36D
	 neffue/lEOjLOS054QUqGyyNuUS3u+IfYaZtgwqG/UHBZ3EmBx27NivoLQMLxJ0mdm
	 CRwWPRXNv21X7Oa5DD3hYsmkEI9cxZHdE5skCHHc8EXw30OkXbefuE1jMR3kyshy2U
	 yzHxCZkIC5NahYTigi6bJSBy9U5RfE0Kesx61X5ZUWashvUyU3YnkGvT/HpNUXXGaG
	 sLcXHRKSMhT5A==
Date: Mon, 27 Sep 2021 22:16:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Murphy Zhou <jencce.kernel@gmail.com>, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: Re: [regression] fs dax xfstests panic
Message-ID: <20210928051610.GI570642@magnolia>
References: <20210927061747.rijhtovxafsot32z@xzhoux.usersys.redhat.com>
 <20210927115116.GB23909@lst.de>
 <20210927230259.GA2706839@magnolia>
 <20210928043426.GA28185@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928043426.GA28185@lst.de>

On Tue, Sep 28, 2021 at 06:34:26AM +0200, Christoph Hellwig wrote:
> On Mon, Sep 27, 2021 at 04:02:59PM -0700, Darrick J. Wong wrote:
> > > > Looping xfstests generic/108 or xfs/279 on mountpoints with fsdax
> > > > enabled can lead to panic like this:
> > > 
> > > Does this still happen with this series:
> > > 
> > > https://lore.kernel.org/linux-block/20210922172222.2453343-1-hch@lst.de/T/#m8dc646a4dfc40f443227da6bb1c77d9daec524db
> > > 
> > > ?
> > 
> > My test machinse all hit this when writeback throttling is enabled, so
> > 
> > Tested-by: Darrick J. Wong <djwong@kernel.org>
> 
> Do you mean the series fixed it for you?

Yes.

--D
