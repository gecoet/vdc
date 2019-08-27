
Class CacheDataService: ICacheDataService {

    $cacheRepository = $null;

    CacheDataService([ICacheRepository] $cacheRepository) {
        $this.cacheRepository = $cacheRepository;
    }
        
    [void] SetByKey([string] $key, [object] $value) {
        
        # converting the object to string
        $valueType = $value.GetType().ToString();
        
        # Adding .Contains("System.Collections.Generic.Dictionary") because
        # Azure deployment outputs is of type of Generic.Dictionary[Sdk.OutputVariables]
        Write-Host "Debugging - Cache Value Type is $valueType"
        if (($valueType -eq "System.Collections.Hashtable") -or `
            ($valueType.Contains("System.Collections.Generic.Dictionary")) -or `
            ($valueType -eq "System.Management.Automation.PSCustomObject") -or `
            ($valueType -eq "System.Object[]") -or `
            ($valueType -eq "System.Object")) {
            $cacheValue = `
                ConvertTo-Json `
                    -InputObject $value `
                    -Compress `
                    -Depth 100;
            Write-Host "String value of cache is $cacheValue";
        }
        else {
            $cacheValue = $value;
        }
        
        # call repository to store the cache
        $this.cacheRepository.Set(
            $key, 
            $cacheValue);
    }

    [object] GetByKey([string] $key) {
        # Retrieve the value from cache using key
        $cache = `
            $this.cacheRepository.GetByKey($key);
        $isJson = $false;

        if ($cache) {
            # Check if the string returned is a JSON string
            $isJson = `
                Test-Json $cache `
                    -ErrorAction SilentlyContinue;
            
            # If we can convert to object, then return converted object 
            # else return string
            #if($isJson) {
            Try {
                $cache = `
                    ConvertFrom-Json `
                        -AsHashtable `
                        -InputObject $cache `
                        -Depth 50;
            }
            Catch {
                
            }
            return $cache;
        }
        else {
            return $null;
        }
    }

    [void] RemoveByKey([string] $key) {
        $this.cacheRepository.RemoveByKey($key);
    }

    [void] Flush() {
        $this.cacheRepository.Flush();
    }

    [array] GetAll() {
        return $this.cacheRepository.GetAll();
    }
}