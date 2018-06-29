Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C76B5202E5356
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jun 2018 17:47:46 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 1B4BAAC015D
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jun 2018 09:47:37 +0900 (JST)
Date: Fri, 29 Jun 2018 09:47:31 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [ndctl PATCH v2] ndctl: Add CONTRIBUTING.md
In-Reply-To: <20180628194839.18791-1-vishal.l.verma@intel.com>
References: <20180628194839.18791-1-vishal.l.verma@intel.com>
Message-Id: <20180629094727.1BE7.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

> We were missing a CONTRIBUTING file to help new contributors follow the
> expected guidelines. Add one that refers to the Linux Kernel for most of
> these things, such as Coding style, Submitting Patches, and the DCO.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  CONTRIBUTING.md | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>  create mode 100644 CONTRIBUTING.md
> 
> diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
> new file mode 100644
> index 0000000..811a8c0
> --- /dev/null
> +++ b/CONTRIBUTING.md
> @@ -0,0 +1,48 @@
> +# Contributing to ndctl
> +
> +Thank you for taking the time to contribute to ndctl.
> +
> +The following is a set of guidelines that we adhere to, and request that
> +contributors follow.
> +
> +1. The libnvdimm (kernel subsystem) and ndctl developers primarily use
> +   the [linux-nvdimm](https://lists.01.org/mailman/listinfo/linux-nvdimm)
> +   mailing list for everything. It is recommended to send patches to
> +   **```linux-nvdimm@lists.01.org```**
> +
> +1. Github [issues](https://github.com/pmem/ndctl/issues) are an acceptable
> +   way to report a problem, but if you just have a question,
> +   [email](mailto:linux-nvdimm@lists.01.org) the above list.
> +
> +1. We follow the Linux Kernel [Coding Style Guide][cs] as applicable.
> +
> +   [cs]: https://www.kernel.org/doc/html/latest/process/coding-style.html
> +
> +1. We follow the Linux Kernel [Submitting Patches Guide][sp] as applicable.
> +
> +   [sp]: https://www.kernel.org/doc/html/latest/process/submitting-patches.html
> +
> +1. We follow the Linux Kernel [DCO][dco] (Developer Certificate of Origin).
> +   The DCO is an attestation attached to every contribution made by every
> +   developer. In the commit message of the contribution, the developer simply
> +   adds a Signed-off-by statement and thereby agrees to the DCO.
> +
> +   [dco]: https://developercertificate.org/
> +
> +1. Github Pull Requests are acceptable mainly for smaller, more obvious fixups,
> +   but won't be merged directly, as Github doesn't allow for the kernel style
> +   flow of patches where a maintainer also signs off on the patches they apply.
> +   Larger changes may need to be sent to the mailing list so that everyone gets
> +   an opportunity to review them.
> +
> +1. **Misc Best Practices:**
> +   1. Use a subject prefix of "ndctl PATCH" (or "ndctl PATCH vN" for a new
> +      revision). This can be automated for a ```git format-patch``` command
> +      by setting a repo-local git config setting:
> +         ```git config format.subjectprefix "ndctl PATCH"```
> +
> +   1. For commit messages: Describe the change and why it was needed. Use a
> +      concise subject line, and a blank line between the subject and the body,
> +      as well as between paragraphs. Use present tense and the imperative mood
> +      (e.g. "Add support for.." instead of "Added support.." or "Adding
> +      support"). Word-wrap to 72 columns.
> -- 
> 2.14.4
> 

Thank you for updating!
Looks good to me.

Reviewed-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
Yasunori Goto


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
