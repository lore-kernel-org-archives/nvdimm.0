Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F6C421275441
 for <linux-nvdimm@lists.01.org>; Wed, 29 May 2019 10:44:05 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id l17so2924309otq.1
 for <linux-nvdimm@lists.01.org>; Wed, 29 May 2019 10:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190528222440.30392-1-vishal.l.verma@intel.com>
 <20190528222440.30392-7-vishal.l.verma@intel.com>
In-Reply-To: <20190528222440.30392-7-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 May 2019 10:43:53 -0700
Message-ID: <CAPcyv4izGNU8iDmnqH1k7CU0iHXqVUpd5YjXGAL4a9UM65geow@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 06/10] libdaxctl: add an interface to get the
 mode for a dax device
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 28, 2019 at 3:24 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> In preparation for a reconfigure-device command, add an interface to
> retrieve the 'mode' of a dax device. This will allow the
> reconfigure-device command (and via daxctl_dev_to_json()), also
> daxctl-list) to print the mode on device listings via a list command or
> immediately after a mode change.
>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Hmm, if we add a daxctl_dev_get_memory() helper to retrieve a context
for doing kmem-related operations could that be a stand-in for
daxctl_dev_get_mode()? I.e. "if (!daxctl_dev_get_memory())
is_devdax..."

I also think it's ok to treat disabled device instances as devdax mode
as "unknown" will just increase user anxiety.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
