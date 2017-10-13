Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A77F202E5CD0
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 16:05:50 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id m198so16526578oig.5
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 16:09:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171013001004.14963-5-vishal.l.verma@intel.com>
References: <20171013001004.14963-1-vishal.l.verma@intel.com>
 <20171013001004.14963-5-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Oct 2017 16:09:21 -0700
Message-ID: <CAPcyv4jrbZVKs3Qf7jsnF=REJ8cdsT0-v830P-rc7rA2sC8RoA@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 4/6] ndctl/test: add a new unit test for
 inject-error
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

On Thu, Oct 12, 2017 at 5:10 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add a new unit test to test all the features of the inject-error
> command.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
