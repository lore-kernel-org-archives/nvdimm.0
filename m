Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 15BFD211B63EF
 for <linux-nvdimm@lists.01.org>; Fri, 18 Jan 2019 13:04:49 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id r62so10085754oie.1
 for <linux-nvdimm@lists.01.org>; Fri, 18 Jan 2019 13:04:49 -0800 (PST)
MIME-Version: 1.0
References: <20190118204357.7282-1-vishal.l.verma@intel.com>
In-Reply-To: <20190118204357.7282-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Jan 2019 13:04:37 -0800
Message-ID: <CAPcyv4g8cpH5J2QNkyg0xUL3E7agwjk48pDgSx8D6kjuRDfC-Q@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, Documentation: Allow for Makefile variables
 in Documentation
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 18, 2019 at 12:44 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> We were starting to accumulate automake variables such as configureation
> file paths that were also referenced in Documentation man pages.
> However, until now, the man pages simply hard coded these paths to their
> default values. If a distribution were to configure such a path to
> something other than the default, the man pages would be out of sync
> with the reality.
>
> Arrange for Makefile variables to be piped into an 'attrs.adoc' target
> (the variables to be piped in this manner still ahve to be listed
> explicitly). The different asciidoc(tor) source files can then include
> attrs.adoc to use these variables.
>
> Finally, convert instances of '/etc/ndctl/monitor.conf' in the monitor
> documentation to use this new facility.
>
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Nice!

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
