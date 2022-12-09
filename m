Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC0963C5
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670606040; x=1702142040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z7IE4fiXaS7oKlKyMlkL5FpaDU2NlOtji0Z/A0adz08=;
  b=mtiIWB6MuhjcavyqVlYy95oVi0ErI8rXzntvWpOZiQJGpAo3BbcV5X+Y
   wUEU2KMiXVdwdjusV4zIdrBD+QxeDNhjmhokvwZK0WigMlYHZrrB5kpzQ
   PSeCN0IbLrgw88Mt4YtSmAXM9jJkQGGQ096xkgtgtvXHxDyJBIhCemFop
   8oGFG35hycjDpJgvZ+B+LnqMAvxcdPPeJWKCmvKoRTtbZWnFF56K4mhJI
   LqedBwbq3dSzSMm1XAHEcsPVp0vYotrUOZbiPPx2niKYRQOC24TvMajfF
   dKrBzTw/erYhN90oHl/b8Xy34h7w8oJCuITSvWoezdONRoc9bf9tf6Dwc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="315142037"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="315142037"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:13:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="771918355"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="771918355"
Received: from xinjunwa-mobl.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.227.125])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:13:42 -0800
Date: Fri, 9 Dec 2022 09:13:40 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
	vishal.l.verma@intel.com, nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 01/18] ndctl/test: Move firmware-update.sh to
 the 'destructive' set
Message-ID: <Y5NsxBeoL5nxSdAI@aschofie-mobl2>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053488383.582963.12851797514973259163.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167053488383.582963.12851797514973259163.stgit@dwillia2-xfh.jf.intel.com>

On Thu, Dec 08, 2022 at 01:28:03PM -0800, Dan Williams wrote:
> The firmware update test attempts a system-suspend test which may break
> systems that have a broken driver, or otherwise are not prepared to support
> suspend.
> 

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> Link: https://github.com/pmem/ndctl/issues/221
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  test/meson.build |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/test/meson.build b/test/meson.build
> index 5953c286d13f..c31d8eac66c5 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -170,7 +170,6 @@ tests = [
>    [ 'btt-errors.sh',          btt_errors,	  'ndctl' ],
>    [ 'hugetlb',                hugetlb,		  'ndctl' ],
>    [ 'btt-pad-compat.sh',      btt_pad_compat,	  'ndctl' ],
> -  [ 'firmware-update.sh',     firmware_update,	  'ndctl' ],
>    [ 'ack-shutdown-count-set', ack_shutdown_count, 'ndctl' ],
>    [ 'rescan-partitions.sh',   rescan_partitions,  'ndctl' ],
>    [ 'inject-smart.sh',        inject_smart,	  'ndctl' ],
> @@ -196,6 +195,7 @@ if get_option('destructive').enabled()
>    mmap_test = find_program('mmap.sh')
>  
>    tests += [
> +    [ 'firmware-update.sh',     firmware_update,	  'ndctl' ],
>      [ 'pmem-ns',           pmem_ns,	   'ndctl' ],
>      [ 'sub-section.sh',    sub_section,	   'dax'   ],
>      [ 'dax-dev',           dax_dev,	   'dax'   ],
> 
