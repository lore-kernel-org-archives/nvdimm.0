Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-eopbgr00063.outbound.protection.outlook.com [40.107.0.63])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 946B72129F032
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jun 2019 04:44:32 -0700 (PDT)
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 18/22] mm: mark DEVICE_PUBLIC as broken
Date: Tue, 25 Jun 2019 11:44:28 +0000
Message-ID: <20190625114422.GA3118@mellanox.com>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-19-hch@lst.de> <20190620192648.GI12083@dhcp22.suse.cz>
 <20190625072915.GD30350@lst.de>
In-Reply-To: <20190625072915.GD30350@lst.de>
Content-Language: en-US
Content-ID: <9099450B868E3548B355AC3B0AFD1F5E@eurprd05.prod.outlook.com>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Michal Hocko <mhocko@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 25, 2019 at 09:29:15AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 20, 2019 at 09:26:48PM +0200, Michal Hocko wrote:
> > On Thu 13-06-19 11:43:21, Christoph Hellwig wrote:
> > > The code hasn't been used since it was added to the tree, and doesn't
> > > appear to actually be usable.  Mark it as BROKEN until either a user
> > > comes along or we finally give up on it.
> > 
> > I would go even further and simply remove all the DEVICE_PUBLIC code.
> 
> I looked into that as I now got the feedback twice.  It would
> create a conflict with another tree cleaning things up around the
> is_device_private defintion, but otherwise I'd be glad to just remove
> it.
> 
> Jason, as this goes through your tree, do you mind the additional
> conflict?

Which tree and what does the resolution look like?

Also, I don't want to be making the decision if we should keep/remove
DEVICE_PUBLIC, so let's get an Ack from Andrew/etc?

My main reluctance is that I know there is HW out there that can do
coherent, and I want to believe they are coming with patches, just
too slowly. But I'd also rather those people defend themselves :P

Thanks,
Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
