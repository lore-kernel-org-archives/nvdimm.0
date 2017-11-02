Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0CD932034A7BA
 for <linux-nvdimm@lists.01.org>; Thu,  2 Nov 2017 14:03:04 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id r128so693357oig.9
 for <linux-nvdimm@lists.01.org>; Thu, 02 Nov 2017 14:06:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171102201356.GD5732@lst.de>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150949214929.24061.10464887309708944817.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171102201356.GD5732@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 2 Nov 2017 14:06:57 -0700
Message-ID: <CAPcyv4g0-kXCXzGo6=3fwaRJTM_4N8BFp+-W71t4Vd_to7LDBA@mail.gmail.com>
Subject: Re: [PATCH 10/15] IB/core: disable memory registration of
 fileystem-dax vmas
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
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Sean Hefty <sean.hefty@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 2, 2017 at 1:13 PM, Christoph Hellwig <hch@lst.de> wrote:
> Any chance we could add a new get_user_pages_longerm or similar
> helper instead of opencoding this in the various callers?

Sounds like a great idea to me, I'll take a look...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
