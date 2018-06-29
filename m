Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8AABE203369D6
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jun 2018 16:59:22 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 1/3] ndctl: simplify JSON print flag handling
Date: Fri, 29 Jun 2018 23:59:19 +0000
Message-ID: <1530316757.7574.19.camel@intel.com>
References: <20180629233927.6232-1-ross.zwisler@linux.intel.com>
 <CAPcyv4h3FxqAFtN_JtODtqa2U_CMxnVePK_h+4DURNocVqvC2w@mail.gmail.com>
In-Reply-To: <CAPcyv4h3FxqAFtN_JtODtqa2U_CMxnVePK_h+4DURNocVqvC2w@mail.gmail.com>
Content-Language: en-US
Content-ID: <AB9E0391797EAD418FE18F79CD2A2044@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-06-29 at 16:51 -0700, Dan Williams wrote:
> On Fri, Jun 29, 2018 at 4:39 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > json_object_to_json_string_ext()'s second argument is a flags field
> > which
> > we always want to be JSON_C_TO_STRING_PRETTY.  We were going to a
> > lot of
> > trouble for this, though.  We had multiple variables set to be this
> > one
> > flag and util_display_json_array() took it as an argument, even
> > though it
> > never varied.
> > 
> > Instead, just pass in the necessary flag when calling
> > json_object_to_json_string_ext(), removing the local variables and
> > the extra
> > argument to util_display_json_array().
> 
> I was thinking of one day supporting a flag other than
> JSON_C_TO_STRING_PRETTY and have it be controlled by the command
> line.
> However that never materialized, and we could always use an
> environment variable to change the json format flag.

Or use jq to do some reformatting. e.g. <cmd> | jq -c should be the the
same as using the JSON_C_TO_STRING_PLAIN flag.

> 
> So,
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
