Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B108D21967BCC
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 14:28:24 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id b6so14816986oia.1
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 14:29:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170613152557.26673-1-vishal.l.verma@intel.com>
References: <20170613152557.26673-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Jun 2017 14:29:02 -0700
Message-ID: <CAPcyv4g-RAezDeG8L1So-5mx4yuZ+GD+XQaMH0W3gqLV_YmG-Q@mail.gmail.com>
Subject: Re: [PATCH] ndctl, completion: show idle namespaces for 'destroy'
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

On Tue, Jun 13, 2017 at 8:25 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The canonical way to destroy a namespace is to first disable it, then
> destroy it. Thus typically, namespaces about to be destroyed will be
> 'idle'. Enable idle namespaces for completion of destroy-namespace.
>

Thanks Vishal, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
