Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56F432267F111
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 16:07:32 -0700 (PDT)
Date: Mon, 9 Apr 2018 17:07:30 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [ndctl PATCH 1/2] ndctl: s/memory/fsdax/ in some user visible
 places
Message-ID: <20180409230730.GA20234@linux.intel.com>
References: <20180409200920.20177-1-ross.zwisler@linux.intel.com>
 <CAPcyv4ho-K3MMOn+mJ5JEcE1_C0CErGL2KY04-hTcPn2GNyGmw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4ho-K3MMOn+mJ5JEcE1_C0CErGL2KY04-hTcPn2GNyGmw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 09, 2018 at 03:10:26PM -0700, Dan Williams wrote:
> On Mon, Apr 9, 2018 at 1:09 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > Adding on to the work started by:
> >
> > commit ebb4fb605e68 ("ndctl, create-namespace: introduce "fsdax" and "devdax" modes")
> 
> I'd say "why" here.

Because having both "memory" and "fsdax" and having to know that they are
aliases is confusing.  It'd be great if we could just choose one term and
stick with it, and I thought the term we had decided on was "fsdax".

> Also, might as well also convert util_namespace_to_json() to emit
> "fsdax" in all cases. I had initially thought there were compat
> concerns with removing the "memory" designation, but it will just
> cause ongoing confusion. Lets kill its output everywhere, but of
> course still accept it as a command input.

Cool, I think that'd be best.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
