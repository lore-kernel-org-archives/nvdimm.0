Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D80962097DD37
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 13:41:17 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <89742c32-e6f0-72d9-b1c8-140d67b57e9f@intel.com>
References: <89742c32-e6f0-72d9-b1c8-140d67b57e9f@intel.com>
 <153186087803.27463.7423668214880824595.stgit@djiang5-desk3.ch.intel.com>
 <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <9360.1531912457@warthog.procyon.org.uk>
 <52ca4099-2816-4a42-9109-22b199975821@intel.com>
Subject: Re: [PATCH v5 06/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
MIME-Version: 1.0
Content-ID: <17730.1531946474.1@warthog.procyon.org.uk>
Date: Wed, 18 Jul 2018 21:41:14 +0100
Message-ID: <17731.1531946474@warthog.procyon.org.uk>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: dhowells@redhat.com, alison.schofield@intel.com, keyrings@vger.kernel.org, keescook@chromium.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dave Jiang <dave.jiang@intel.com> wrote:

> A thought occurred to me. For password update, would it make sense to do
> this instead:
> 1. get the existing key by: request_key("nvdimm:xxxxxxxx")
> 2. get the new key by: request_key("nvdimm.update:xxxxxxxx")
> 3. verify key with hardware
> 	on success, copy new payload to existing key payload
> 4. invalidate "nvdimm.update" key
> 
> This way then we won't have to mess with needing the invalidated key to
> be garbage collected. Thoughts?

Can you tell me at what points you actually access the key?

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
