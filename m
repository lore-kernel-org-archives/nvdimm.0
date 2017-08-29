Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x241.google.com (mail-it0-x241.google.com
 [IPv6:2607:f8b0:4001:c0b::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C15202095DE5A
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 15:04:28 -0700 (PDT)
Received: by mail-it0-x241.google.com with SMTP id w204so997747ita.1
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 15:07:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170829213721.GA27686@linux.intel.com>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
 <20170824160144.GA14287@infradead.org> <20170829212002.GA2154@infradead.org>
 <20170829213721.GA27686@linux.intel.com>
From: Randy Dodgen <rdodgen@gmail.com>
Date: Tue, 29 Aug 2017 15:07:08 -0700
Message-ID: <CAC9jV4p62Q-6FnPumac1mASK-PYjyAbTch0bzwWPh3W-dGdsVQ@mail.gmail.com>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dodgen <dodgen@google.com>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

An xfstest is a fine idea. I've started some work on that.

On Tue, Aug 29, 2017 at 2:37 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Tue, Aug 29, 2017 at 02:20:02PM -0700, Christoph Hellwig wrote:
>> Randy, any chance yto at least share a test script so that others
>> can wire it up for the test suite?
>
> I made a reproducer for my testing. I'll make an xfstest if Randy isn't able
> to.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
