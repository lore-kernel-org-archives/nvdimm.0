Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12DC221E70D23
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 14:34:42 -0700 (PDT)
Date: Tue, 29 Aug 2017 15:37:21 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Message-ID: <20170829213721.GA27686@linux.intel.com>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
 <20170824160144.GA14287@infradead.org>
 <20170829212002.GA2154@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170829212002.GA2154@infradead.org>
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
Cc: rdodgen@gmail.com, Randy Dodgen <dodgen@google.com>, linux-ext4@vger.kernel.org, tytso@mit.edu, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 29, 2017 at 02:20:02PM -0700, Christoph Hellwig wrote:
> Randy, any chance yto at least share a test script so that others
> can wire it up for the test suite?

I made a reproducer for my testing. I'll make an xfstest if Randy isn't able
to.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
