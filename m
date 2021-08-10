Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8B7177
	for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 22:59:06 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso4144892pjb.1
        for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 15:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HRkMXHTMybBop5nj9vE+F/ExnUOUoVNnmndDFIHcH0I=;
        b=uNJeGRamEnEFjdKxtCfMVbElFNnGOhngxPOLwevH571t58EdPxu+LmRcxVPl+5JC6Q
         PIv8ut4uXjVxqEBVM20owC7XbdZ+QEYJjdbk6JnaSsqea9p64bo75+voJsDBR2vAyhb2
         h3N5S7lr/yF9E4RitQeDLIICsU6IEXndJ9v32fBcsJ+QlkO77Alg5D+bjm30CawFwJuM
         rqiPXP+X8/2vTrNaH6qleGZbAEJFDyiiTi7joAP5sdfm7qFeKZ50tzwp77D8An+5gNqT
         znKmXDsD7jkv4RNykfhr7XRF4LXNaC+ZI6NoOTmtXDGl9B7HSILj+72Piz3BgsV1lbHP
         5Nwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HRkMXHTMybBop5nj9vE+F/ExnUOUoVNnmndDFIHcH0I=;
        b=eMbe9lqM+EyGpYty+iy2gvcnseDd32HORgnhOX179eMTUZAGcSUzEENKEuwifYO/l6
         1iNs4okCb30K/R1t6LVXBYJV4/RmcEdn95OOoQ/dT3HGGJKYbmLFwUG/9t/IwQ6ZY8pT
         Kk+t/87myyr0Xo1eAww75aXyroKb00kKPW7Qeng7TcdZBWSjT+rJs1bFGVHht+wj3LY5
         3GCU8rX2qJoIA8hKKEOpud8yDKX041G+TvtNTol0l5P2hk7+6Q5ZkYrnh7C6opPFd1p8
         2bELMsRS6eTrZV/4K7E+24uNO6JOh9Wx+Doi8xRIAVmga1bzCrISV1UVB1YmUQ2/csua
         9l6w==
X-Gm-Message-State: AOAM530yBwp8tnUoFYkqP61VK75SZxxn130ZwOMT1TA/KQl6jWAg9qIv
	seMKvCgRInVVcssDLOB7cIa2M8OGADGKylhpDkkQBA==
X-Google-Smtp-Source: ABdhPJydPuvNwpWjIHv6qSPvaP+yefqwQ3NHX9vnQ3RlIcIZ2Bozcn8E9oljtXp7AjuNDMpyWl0XefdhLCvHUvF+l28=
X-Received: by 2002:a17:903:22c6:b029:12c:8da8:fd49 with SMTP id
 y6-20020a17090322c6b029012c8da8fd49mr1618387plg.79.1628636345647; Tue, 10 Aug
 2021 15:59:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210810221023.h65s3i3ephzt7m2w@intel.com>
In-Reply-To: <20210810221023.h65s3i3ephzt7m2w@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Aug 2021 15:58:55 -0700
Message-ID: <CAPcyv4j_QQDjOBPoLKpR2XDXm40SFmdOoyEeH2TscSmbnyO_ag@mail.gmail.com>
Subject: Re: [PATCH 00/23] cxl_test: Enable CXL Topology and UAPI regression tests
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 10, 2021 at 3:10 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 21-08-09 15:27:47, Dan Williams wrote:
> > As mentioned in patch 20 in this series the response of upstream QEMU
> > community to CXL device emulation has been underwhelming to date. Even
> > if that picked up it still results in a situation where new driver
> > features and new test capabilities for those features are split across
> > multiple repositories.
> >
> > The "nfit_test" approach of mocking up platform resources via an
> > external test module continues to yield positive results catching
> > regressions early and often. Repeat that success with a "cxl_test"
> > module to inject custom crafted topologies and command responses into
> > the CXL subsystem's sysfs and ioctl UAPIs.
> >
> > The first target for cxl_test to verify is the integration of CXL with
> > LIBNVDIMM and the new support for the CXL namespace label + region-label
> > format. The first 11 patches introduce support for the new label format.
> >
> > The next 9 patches rework the CXL PCI driver and to move more common
> > infrastructure into the core for the unit test environment to reuse. The
> > largest change here is disconnecting the mailbox command processing
> > infrastructure from the PCI specific transport. The unit test
> > environment replaces the PCI transport with a custom backend with mocked
> > responses to command requests.
> >
> > Patch 20 introduces just enough mocked functionality for the cxl_acpi
> > driver to load against cxl_test resources. Patch 21 fixes the first bug
> > discovered by this framework, namely that HDM decoder target list maps
> > were not being filled out.
> >
> > Finally patches 22 and 23 introduce a cxl_test representation of memory
> > expander devices. In this initial implementation these memory expander
> > targets implement just enough command support to pass the basic driver
> > init sequence and enable label command passthrough to LIBNVDIMM.
> >
> > The topology of cxl_test includes:
> > - (4) platform fixed memory windows. One each of a x1-volatile,
> >   x4-volatile, x1-persistent, and x4-persistent.
> > - (4) Host bridges each with (2) root ports
> > - (8) CXL memory expanders, one for each root port
> > - Each memory expander device supports the GET_SUPPORTED_LOGS, GET_LOG,
> >   IDENTIFY, GET_LSA, and SET_LSA commands.
> >
> > Going forward the expectation is that where possible new UAPI visible
> > subsystem functionality comes with cxl_test emulation of the same.
> >
> > The build process for cxl_test is:
> >
> >     make M=tools/testing/cxl
> >     make M=tools/testing/cxl modules_install
> >
> > The implementation methodology of the test module is the same as
> > nfit_test where the bulk of the emulation comes from replacing symbols
> > that cxl_acpi and the cxl_core import with mocked implementation of
> > those symbols. See the "--wrap=" lines in tools/testing/cxl/Kbuild. Some
> > symbols need to be replaced, but are local to the modules like
> > match_add_root_ports(). In those cases the local symbol is marked __weak
> > with a strong implementation coming from tools/testing/cxl/. The goal
> > being to be minimally invasive to production code paths.
>
> I went through everything except the very last patch, which I'll try to get to
> tomorrow when my brain is working a bit better. It looks fine to me overall. I'd
> like if we could remove code duplication in the mock driver, but perhaps that's
> the nature of the beast here.

Well, maybe not. I.e. I don't think it would be out of the question to
wrap this common sequence into a helper that both cxl_pci and
cxl_mock_mem share:

        rc = cxl_mem_enumerate_cmds(cxlm);
        if (rc)
                return rc;

        rc = cxl_mem_identify(cxlm);
        if (rc)
                return rc;

        rc = cxl_mem_create_range_info(cxlm);
        if (rc)
                return rc;

        cxlmd = devm_cxl_add_memdev(dev, cxlm);
        if (IS_ERR(cxlmd))
                return PTR_ERR(cxlmd);

        if (range_len(&cxlm->pmem_range) && IS_ENABLED(CONFIG_CXL_PMEM))
                rc = devm_cxl_add_nvdimm(dev, cxlmd);

...or are you thinking of a different place where there's duplication?
