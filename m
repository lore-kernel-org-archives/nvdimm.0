Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3C0F42050AAF6
 for <linux-nvdimm@lists.01.org>; Wed, 29 Mar 2017 11:01:13 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id r203so11973882oib.3
 for <linux-nvdimm@lists.01.org>; Wed, 29 Mar 2017 11:01:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170329173616.7571-1-vishal.l.verma@intel.com>
References: <20170329173616.7571-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Mar 2017 11:01:11 -0700
Message-ID: <CAPcyv4iOnR+3jD-h7UUu_z5uSnQHzwRLivjVSZCrJGDuXPguzA@mail.gmail.com>
Subject: Re: [ndctl PATCH] completion: updates for file name completion
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

On Wed, Mar 29, 2017 at 10:36 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add file name completion for the --input and --output arguments of
> read-labels and the new write-labels commands.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Thanks! Applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
