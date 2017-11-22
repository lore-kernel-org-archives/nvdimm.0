Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CCCF921B00DF2
 for <linux-nvdimm@lists.01.org>; Tue, 21 Nov 2017 21:02:42 -0800 (PST)
Received: by mail-ot0-x233.google.com with SMTP id s4so12578917ote.4
 for <linux-nvdimm@lists.01.org>; Tue, 21 Nov 2017 21:06:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171121234053.32570-1-vishal.l.verma@intel.com>
References: <20171121234053.32570-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Nov 2017 21:06:57 -0800
Message-ID: <CAPcyv4hnxzXPv1gG9pZ0okDtjEDGa_J4sjbth-La=Bo0cEj-dA@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, bash-completion: updates for --mode options
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

On Tue, Nov 21, 2017 at 3:40 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> With the updates to --mode for create-namespace, deprecate the old names
> from bash completion. The man page removes mention of the old names, so
> remove them from the completion output as well to avoid confusion.
>
> Add the new names into the mode filtering scheme alongside the old names
> so that the same filtering behaviour is seen regardless of whether a
> user supplies old or new names.

Thanks Vishal, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
