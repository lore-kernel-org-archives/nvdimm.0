Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 60D84221660EE
 for <linux-nvdimm@lists.01.org>; Wed, 29 Nov 2017 09:09:35 -0800 (PST)
Received: by mail-oi0-x22e.google.com with SMTP id w131so2910457oiw.0
 for <linux-nvdimm@lists.01.org>; Wed, 29 Nov 2017 09:13:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171129171100.6654-1-vishal.l.verma@intel.com>
References: <20171129171100.6654-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Nov 2017 09:13:58 -0800
Message-ID: <CAPcyv4h2MCSsBjNHiBwVmMoXGCdTMhrohi5NQrBZazzzeZv4ZQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v2] rpmbuild: check for rpmbuild working directories
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

On Wed, Nov 29, 2017 at 9:11 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The rpmbuild and make-git-snapshot assume that the various ~/rpmbuild/*
> directories are present. In case they weren't, git-archive would fail
> with something like:
>
>   /root/rpmbuild/SOURCES/ndctl-58.2.38.g8ad8f4c.tar.gz: No such file or directory
>
> Add a check to make sure they are present, and exit out with a relevant
> message.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
