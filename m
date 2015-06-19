Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1434744987.11808.105.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 3/3] libnvdimm: Add sysfs numa_node to NVDIMM devices
From: Toshi Kani <toshi.kani@hp.com>
Date: Fri, 19 Jun 2015 14:16:27 -0600
In-Reply-To: <5584752A.6040706@gmail.com>
References: <1434737914-18466-1-git-send-email-toshi.kani@hp.com>
	 <1434737914-18466-4-git-send-email-toshi.kani@hp.com>
	 <5584752A.6040706@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Brice Goglin <brice.goglin@gmail.com>
Cc: rjw@rjwysocki.net, dan.j.williams@intel.com, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-06-19 at 22:01 +0200, Brice Goglin wrote:
> Do you have local_cpus and local_cpulist attributes as well?
> User-space tools such as hwloc use those for binding near I/O devices,
> although I guess we could have some CPU-less NVDIMM NUMA nodes?

No, the patch does not create local_cpus and local_cpulist.  I will look
into hwloc, and support it as a next item if it makes sense to NVDIMM.

Thanks for the input!
-Toshi


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
