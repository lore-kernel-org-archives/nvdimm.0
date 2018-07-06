Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 81011211F8881
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 11:30:44 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id 13-v6so25172948ois.1
 for <linux-nvdimm@lists.01.org>; Fri, 06 Jul 2018 11:30:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180706182841.16869-1-vishal.l.verma@intel.com>
References: <20180706182841.16869-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Jul 2018 11:30:43 -0700
Message-ID: <CAPcyv4hVEeHqr9agUbW0d22tmGJQ2kt=2ff2UJ4FWqbNJpkbbw@mail.gmail.com>
Subject: Re: [ndctl PATCH] libndctl: fix the uninject-error API actually
 injecting errors
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
Cc: Tomasz Rochumski <tomasz.rochumski@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 6, 2018 at 11:28 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The addition of the v2 APIs introduced a bug when they rerouted the
> old APIs to call the new v2 ones. ndctl_namespace_uninject_error()
> called ndctl_namespace_inject_error2() instead of
> ndctl_namespace_uninject_error2().

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
