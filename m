Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14AC2CA4
	for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 07:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=vcE5xITae30eveBT3POA+xHhwo2Q6buP3s15knpDWAk=; b=1NvmtU84iD7rhEWYoHr3V3n88g
	OAJv7aoNOrpLdpLwN8Oz1upyeMGK/mS64MImUsI38e4fdymihSix5zkisblNC5odr4juDFRln35AQ
	EzhZztmT5R5QcInMeeDB5xf3XRyYjdi+efc29SWqeqZkXVbEW39ooh60jz/vKIzSsU7nlldOK0p0/
	ftgA8nvk6MWFFruogKAYWMmVVquHEwUgBJbKRT2wpBOblDRSsQeMhPsnKQf/JGTwwnlBlf/lAOCSJ
	/3iBEI/gRQZS6DLZRwJBFGHWhHKWsgvIMqgVl6T6Y2onPefoluFKObDyY0Q6PSGBnCX4xAq40mGvI
	DFEH4FAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mxlTD-0040QN-VT; Thu, 16 Dec 2021 07:46:31 +0000
Date: Wed, 15 Dec 2021 23:46:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, dan.j.williams@intel.com, david@fromorbit.com,
	jane.chu@oracle.com
Subject: Re: [PATCH v8 7/9] dax: add dax holder helper for filesystems
Message-ID: <Ybru12651I+lETBq@infradead.org>
References: <20211202084856.1285285-1-ruansy.fnst@fujitsu.com>
 <20211202084856.1285285-8-ruansy.fnst@fujitsu.com>
 <Ybi8pmieExZbd/Ee@infradead.org>
 <2c0d1b44-5b7f-f4d0-a7ca-0cf692a0cdd4@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c0d1b44-5b7f-f4d0-a7ca-0cf692a0cdd4@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 15, 2021 at 10:21:00AM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2021/12/14 23:47, Christoph Hellwig 写道:
> > On Thu, Dec 02, 2021 at 04:48:54PM +0800, Shiyang Ruan wrote:
> > > Add these helper functions, and export them for filesystem use.
> > 
> > What is the point of adding these wrappers vs just calling the
> > underlying functions?
> 
> I added them so that they can be called in a friendly way, even if
> CONFIG_DAX is off.  Otherwise, we need #if IS_ENABLED(CONFIG_DAX) to wrap
> them where they are called.

No need for wrappers, you can stub out the underlying functions as well.
