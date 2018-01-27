Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x235.google.com (mail-ot0-x235.google.com
 [IPv6:2607:f8b0:4003:c0f::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBF772222C22B
 for <linux-nvdimm@lists.01.org>; Fri, 26 Jan 2018 18:44:33 -0800 (PST)
Received: by mail-ot0-x235.google.com with SMTP id f100so2086857otf.3
 for <linux-nvdimm@lists.01.org>; Fri, 26 Jan 2018 18:50:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180125164750.GB31752@infradead.org>
References: <CAPcyv4gQNM9RbTbRWKnG6Vby_CW9CJ9EZTARsVNi=9cas7ZR2A@mail.gmail.com>
 <20180125072351.GA11093@infradead.org> <20180125160802.GD10706@ziepe.ca>
 <20180125164750.GB31752@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Jan 2018 18:50:02 -0800
Message-ID: <CAPcyv4hi98RDD=F1rhumgCF+UiOisidmeAVrDePrTzF1ArXj4A@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Filesystem-DAX, page-pinning, and RDMA
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma <linux-rdma@vger.kernel.org>, linux-nvdimm@lists.01.org, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, lsf-pc@lists.linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 25, 2018 at 8:47 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Jan 25, 2018 at 09:08:02AM -0700, Jason Gunthorpe wrote:
>> On Wed, Jan 24, 2018 at 11:23:51PM -0800, Christoph Hellwig wrote:
>> > On Wed, Jan 24, 2018 at 07:56:02PM -0800, Dan Williams wrote:
>> > > Particular people that would be useful to have in attendance are
>> > > Michal Hocko, Christoph Hellwig, and Jason Gunthorpe (cc'd).
>> >
>> > I won't be able to make it - I'll have to do election work and
>> > count the ballots for our city council and mayor election.
>>
>> I also have a travel conflict for that week in April and cannot make
>> it.
>
> Are any of you going to be in the Bay Area in February for Usenix
> FAST / LinuxFAST?

I'll be around, but that said I still think it's worthwhile to have
this conversation at LSF/MM. While we have a plan for filesystem-dax
vs RDMA, there's still the open implications for the mm in other
scenarios. I see Michal has also proposed this topic.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
