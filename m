Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3314521A0BA8D
 for <linux-nvdimm@lists.01.org>; Mon,  8 May 2017 10:00:13 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id w10so57833224oif.0
 for <linux-nvdimm@lists.01.org>; Mon, 08 May 2017 10:00:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170426224307.28075-1-vishal.l.verma@intel.com>
References: <20170426224307.28075-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 8 May 2017 10:00:11 -0700
Message-ID: <CAPcyv4hHRf6MEUxj1WvOjb9+JUmTBEh0x4RGGXEHg=kJT+anmg@mail.gmail.com>
Subject: Re: [PATCH] nvdimm,
 btt: make sure initializing new metadata clears poison
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 26, 2017 at 3:43 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> If we had badblocks/poison in the metadata area of a BTT, recreating the
> BTT would not clear the poison in all cases, notably the flog area. This
> is because rw_bytes will only clear errors if the request being sent
> down is 512B aligned and sized.
>
> Make sure that when writing the map and info blocks, the rw_bytes being
> sent are of the correct size/alignment. For the flog, instead of doing
> the smaller log_entry writes only, first do a 'wipe' of the entire area
> by writing zeroes in large enough chunks so that errors get cleared.

These eventually nsio_rw_bytes() while the namespace is claimed by a
btt instance, so this collides with the hack to disable error clearing
for btt. If we want to fix this up for 4.12 I think we need to pass a
'flags' parameter to the ->rw_bytes() routine to indicate that we are
in atomic context (NVDIMM_IO_ATOMIC), rather than assuming that all
BTT I/O is atomic. Care to code that up? I think we can include it in
a pull request before the merge window closes.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
